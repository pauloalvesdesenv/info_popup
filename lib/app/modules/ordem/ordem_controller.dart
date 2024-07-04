import 'package:aco_plus/app/core/client/firestore/collections/cliente/cliente_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/ordem/models/ordem_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/enums/pedido_status.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/enums/pedido_tipo.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_history_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_produto_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_produto_status_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_status_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/produto/produto_model.dart';
import 'package:aco_plus/app/core/client/firestore/firestore_client.dart';
import 'package:aco_plus/app/core/dialogs/loading_dialog.dart';
import 'package:aco_plus/app/core/enums/sort_type.dart';
import 'package:aco_plus/app/core/extensions/string_ext.dart';
import 'package:aco_plus/app/core/models/app_stream.dart';
import 'package:aco_plus/app/core/services/hash_service.dart';
import 'package:aco_plus/app/core/services/notification_service.dart';
import 'package:aco_plus/app/core/utils/global_resource.dart';
import 'package:aco_plus/app/modules/automatizacao/automatizacao_controller.dart';
import 'package:aco_plus/app/modules/ordem/ui/ordem_produto_status_bottom.dart';
import 'package:aco_plus/app/modules/ordem/view_models/ordem_view_model.dart';
import 'package:aco_plus/app/modules/pedido/pedido_controller.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

final ordemCtrl = OrdemController();

class OrdemController {
  static final OrdemController _instance = OrdemController._();

  OrdemController._();

  factory OrdemController() => _instance;

  final AppStream<OrdemUtils> utilsStream =
      AppStream<OrdemUtils>.seed(OrdemUtils());
  OrdemUtils get utils => utilsStream.value;

  void onInit() {
    utilsStream.add(OrdemUtils());
    FirestoreClient.ordens.fetch();
  }

  final AppStream<OrdemCreateModel> formStream = AppStream<OrdemCreateModel>();
  OrdemCreateModel get form => formStream.value;

  void onInitCreatePage(OrdemModel? ordem) {
    formStream
        .add(ordem != null ? OrdemCreateModel.edit(ordem) : OrdemCreateModel());
  }

  List<PedidoProdutoModel> getPedidosPorProduto(ProdutoModel produto) {
    List<PedidoProdutoModel> pedidos = [];
    for (var pedido in FirestoreClient.pedidos.data
        .where((e) =>
            form.cliente.text.isEmpty ||
            e.cliente.nome.toCompare.contains(form.cliente.text.toCompare))
        .toList()) {
      for (var pedidoProduto in pedido.produtos
          .where((e) =>
              e.status.status == PedidoProdutoStatus.separado &&
              e.produto.id == produto.id)
          .toList()) {
        pedidos.add(pedidoProduto);
      }
    }
    onSortPedidos(pedidos);
    return pedidos;
  }

  List<PedidoProdutoModel> getPedidosPorProdutoEdit(OrdemModel ordem) {
    final pedidos = ordem.produtos
        .where((e) =>
            form.cliente.text.isEmpty ||
            e.cliente.nome.toCompare.contains(form.cliente.text.toCompare))
        .toList();
    onSortPedidos(pedidos);

    return pedidos;
  }

  List<OrdemModel> getOrdensFiltered(String search, List<OrdemModel> ordens) {
    if (search.length < 3) return ordens;
    List<OrdemModel> filtered = [];
    for (final ordem in ordens) {
      if (ordem.id.toString().toCompare.contains(search.toCompare)) {
        filtered.add(ordem);
      }
    }
    return filtered;
  }

  Future<void> onConfirm(_, OrdemModel? ordem) async {
    try {
      final ordem = form.toOrdemModel();
      onValid(ordem);
      if (form.isEdit) {
        await onEdit(_, ordem);
      } else {
        await onCreate(_);
      }
    } catch (_) {
      NotificationService.showNegative('Erro', _.toString(),
          position: NotificationPosition.bottom);
    }
  }

  Future<void> onCreate(_) async {
    form.id =
        'OP${form.produto!.descricao.replaceAll('m', '').replaceAll('.', '')}${form.id}';

    final ordemCriada = form.toOrdemModel();
    await FirestoreClient.ordens.add(ordemCriada);
    await FirestoreClient.pedidos.fetch();
    await pedidoCtrl.onVerifyPedidoStatus();
    await automatizacaoCtrl.onSetStepByPedidoStatus(ordemCriada.pedidos);

    Navigator.pop(_);

    NotificationService.showPositive(
        'Ordem Adicionada', 'Operação realizada com sucesso',
        position: NotificationPosition.bottom);
  }

  Future<void> onEdit(_, OrdemModel ordem) async {
    await FirestoreClient.pedidos.fetch();
    ordem.produtos.removeWhere((e) => e.status.status.index == 0);
    final result = form.toOrdemModel();
    await FirestoreClient.ordens.update(result);
    await automatizacaoCtrl.onSetStepByPedidoStatus(result.pedidos);
    Navigator.pop(_);
    Navigator.pop(_);
    NotificationService.showPositive(
        'Ordem Editada', 'Operação realizada com sucesso',
        position: NotificationPosition.bottom);
  }

  Future<void> onDelete(_, OrdemModel ordem) async {
    if (await _isDeleteUnavailable(ordem)) return;
    for (var pedidoProduto in ordem.produtos
        .map((e) =>
            FirestoreClient.pedidos.getProdutoByPedidoId(e.pedidoId, e.id))
        .toList()) {
      pedidoProduto.statusess.clear();
      pedidoProduto.statusess.add(PedidoProdutoStatusModel(
          id: HashService.get,
          status: PedidoProdutoStatus.separado,
          createdAt: DateTime.now()));
      await FirestoreClient.pedidos
          .update(FirestoreClient.pedidos.getById(pedidoProduto.pedidoId));
    }
    ordem.produtos.clear();
    await FirestoreClient.ordens.delete(ordem);
    await automatizacaoCtrl.onSetStepByPedidoStatus(ordem.pedidos);
    pop(_);

    NotificationService.showPositive(
        'Ordem Excluida', 'Operação realizada com sucesso',
        position: NotificationPosition.bottom);
  }

  Future<bool> _isDeleteUnavailable(OrdemModel ordem) async =>
      !await onDeleteProcess(
        deleteTitle: 'Deseja excluir a ordem?',
        deleteMessage: 'Todos seus dados da ordem apagados do sistema',
        infoMessage:
            'Para excluir a ordem todos os produtos devem estar em "Aguardando Produção".',
        conditional: !ordem.produtos.every((e) =>
            e.status.status == PedidoProdutoStatus.aguardandoProducao ||
            e.status.status == PedidoProdutoStatus.separado),
      );

  void onValid(OrdemModel? ordem) {
    if (form.produto == null) {
      throw Exception('Selecione o produto');
    }
    if (_checkIsEmpty(ordem)) {
      throw Exception('A lista de produtos não pode ser vazia');
    }
  }

  bool _checkIsEmpty(OrdemModel? ordem) {
    final edit = form.toOrdemModel().copyWith();
    edit.produtos
        .removeWhere((e) => e.status.status.index <= 1 && !e.isSelected);
    return edit.produtos.isEmpty;
  }

  void onSortPedidos(List<PedidoProdutoModel> pedidos) {
    bool isAsc = form.sortOrder == SortOrder.asc;
    switch (form.sortType) {
      case SortType.localizator:
        pedidos.sort((a, b) => isAsc
            ? a.cliente.nome.compareTo(b.cliente.nome)
            : b.cliente.nome.compareTo(a.cliente.nome));
        break;
      case SortType.alfabetic:
        pedidos.sort((a, b) => isAsc
            ? a.cliente.nome.compareTo(b.cliente.nome)
            : b.cliente.nome.compareTo(a.cliente.nome));
        break;
      case SortType.createdAt:
        pedidos.sort((a, b) => isAsc
            ? (a.pedido.deliveryAt ?? DateTime.now())
                .compareTo((b.pedido.deliveryAt ?? DateTime.now()))
            : (b.pedido.deliveryAt ?? DateTime.now())
                .compareTo((a.pedido.deliveryAt ?? DateTime.now())));
        break;
      default:
    }
  }

  //ORDEM
  final AppStream<OrdemModel> ordemStream = AppStream<OrdemModel>();
  OrdemModel get ordem => ordemStream.value;

  void onInitPage(OrdemModel ordem) {
    ordemStream.add(ordem);
  }

  List<ClienteModel> getClientesByProduto(ProdutoModel? produto) {
    if (produto == null) return [];
    return FirestoreClient.pedidos.data
        .where((e) => e.produtos.map((e) => e.produto.id).contains(produto.id))
        .toList()
        .map((e) => e.cliente.id)
        .toSet()
        .map((e) => FirestoreClient.clientes.data.firstWhere((f) => f.id == e))
        .toList();
  }

  List<ObraModel> getObrasByClienteAndProduto(
      ClienteModel? cliente, ProdutoModel? produto) {
    if (cliente == null || produto == null) return [];
    return FirestoreClient.pedidos.data
        .where((e) =>
            e.cliente.id == cliente.id &&
            e.produtos.map((e) => e.produto.id).contains(produto.id))
        .toList()
        .map((e) => e.obra.id)
        .toSet()
        .map((e) => cliente.obras.firstWhere((f) => f.id == e))
        .toList();
  }

  List<PedidoProdutoModel> getProduto(
      ClienteModel? cliente, ObraModel? obra, ProdutoModel? produto) {
    if (cliente == null || obra == null || produto == null) return [];
    final pedidos = FirestoreClient.pedidos.data
        .where((e) =>
            e.cliente.id == cliente.id &&
            e.obra.id == obra.id &&
            e.produtos.map((e) => e.produto.id).contains(produto.id))
        .toList();
    if (pedidos.isEmpty) return [];
    List<PedidoProdutoModel> pedidoProdutos = [];
    for (final pedido in pedidos) {
      pedidoProdutos
          .add(pedido.produtos.firstWhere((e) => e.produto.id == produto.id));
    }
    return pedidoProdutos
        // .where((e) => !form.produtos.map((e) => e.produto.id).contains(e.produto.id))
        .toList();
  }

  void onChangeProdutoStatus(PedidoProdutoModel produto) async {
    final produtoStatus = produto.statusess.last.status;
    final status = await showOrdemProdutoStatusBottom(produtoStatus);
    if (status == null || produtoStatus == status) return;
    showLoadingDialog();
    final statusModel = PedidoProdutoStatusModel.create(status);
    final pedido = FirestoreClient.pedidos.getById(produto.pedidoId);
    pedido.produtos[pedido.iOfProductById(produto.id)].statusess
        .add(statusModel);
    await FirestoreClient.pedidos.update(pedido);
    await FirestoreClient.ordens.fetch();
    final result = FirestoreClient.ordens.getById(ordem.id);
    ordemStream.add(result);
    await FirestoreClient.ordens.update(ordem);
    await onSetStatusPedido(produto);
    await automatizacaoCtrl.onSetStepByPedidoStatus(ordem.pedidos);
    await FirestoreClient.ordens.fetch();
    FirestoreClient.ordens.dataStream.update();
    Navigator.pop(contextGlobal);
  }

  Future<void> onSetStatusPedido(PedidoProdutoModel produto) async {
    final pedido = FirestoreClient.pedidos.getById(produto.pedidoId);
    final status = PedidoStatusModel.create(getPedidoStatusByProduto(pedido));
    pedido.statusess.add(status);
    pedidoCtrl.onAddHistory(
        pedido: pedido,
        data: status,
        action: PedidoHistoryAction.update,
        type: PedidoHistoryType.status);
    ordemStream.update();
    await FirestoreClient.pedidos.update(pedido);
  }

  PedidoStatus getPedidoStatusByProduto(PedidoModel pedido) {
    bool isAllDone = pedido.produtos
        .every((e) => e.status.status == PedidoProdutoStatus.pronto);
    if (isAllDone) {
      return pedido.tipo == PedidoTipo.cd
          ? PedidoStatus.pronto
          : PedidoStatus.aguardandoProducaoCDA;
    } else {
      bool isAllAguardandoProducao = pedido.produtos.every(
          (e) => e.status.status == PedidoProdutoStatus.aguardandoProducao);

      return isAllAguardandoProducao
          ? PedidoStatus.aguardandoProducaoCD
          : PedidoStatus.produzindoCD;
    }
  }
}
