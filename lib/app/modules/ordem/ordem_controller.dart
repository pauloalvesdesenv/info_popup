import 'package:aco_plus/app/core/client/firestore/collections/ordem/models/ordem_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_history_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_produto_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_produto_status_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/produto/produto_model.dart';
import 'package:aco_plus/app/core/client/firestore/firestore_client.dart';
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
    await automatizacaoCtrl.onSetStepByPedidoStatus(ordemCriada.pedidos.map((e) => FirestoreClient.pedidos.getById(e.id)).toList());

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

  void onInitPage(String ordemId) {
    ordemStream.add(getOrdemById(ordemId));
  }

  OrdemModel getOrdemById(String ordemId) {
    final ordem = FirestoreClient.ordens.getById(ordemId);
    return ordem;
  }

  void setOrdem(OrdemModel ordem) {
    ordemStream.add(ordem);
  }

  void showBottomChangeProdutoStatus(PedidoProdutoModel produto) async {
    final produtoStatus = produto.statusess.last.status;
    final status = await showOrdemProdutoStatusBottom(produtoStatus);
    if (status == null || produtoStatus == status) return;
    await onChangeProdutoStatus(produto, status);
  }

  Future<void> onChangeProdutoStatus(
      PedidoProdutoModel produto, PedidoProdutoStatus status) async {
    await FirestoreClient.pedidos.updateProdutoStatus(produto, status);
    final pedido = await FirestoreClient.pedidos.updatePedidoStatus(produto);
    if (pedido != null) await updateFeaturesByPedidoStatus(pedido);
    await FirestoreClient.ordens.fetch();
    setOrdem(getOrdemById(ordem.id));
  }

  Future<void> updateFeaturesByPedidoStatus(PedidoModel pedido) async {
    await automatizacaoCtrl.onSetStepByPedidoStatus([pedido]);
    pedidoCtrl.onAddHistory(
        pedido: pedido,
        data: pedido.statusess.last,
        action: PedidoHistoryAction.update,
        type: PedidoHistoryType.status);
  }
}
