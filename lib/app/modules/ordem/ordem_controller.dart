import 'package:aco_plus/app/core/client/firestore/collections/cliente/cliente_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/ordem/models/ordem_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_produto_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/produto/produto_model.dart';
import 'package:aco_plus/app/core/client/firestore/firestore_client.dart';
import 'package:aco_plus/app/core/extensions/string_ext.dart';
import 'package:aco_plus/app/core/models/app_stream.dart';
import 'package:aco_plus/app/core/services/notification_service.dart';
import 'package:aco_plus/app/core/utils/global_resource.dart';
import 'package:aco_plus/app/modules/ordem/view_models/ordem_view_model.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

final ordemCtrl = OrdemController();
OrdemModel get ordem => ordemCtrl.ordem;

class OrdemController {
  static final OrdemController _instance = OrdemController._();

  OrdemController._();

  factory OrdemController() => _instance;

  final AppStream<OrdemUtils> utilsStream = AppStream<OrdemUtils>.seed(OrdemUtils());
  OrdemUtils get utils => utilsStream.value;

  final AppStream<OrdemCreateModel> formStream = AppStream<OrdemCreateModel>();
  OrdemCreateModel get form => formStream.value;

  void onInitCreatePage(OrdemModel? ordem) {
    formStream.add(ordem != null ? OrdemCreateModel.edit(ordem) : OrdemCreateModel());
  }

  List<OrdemModel> getOrdemesFiltered(String search, List<OrdemModel> ordens) {
    if (search.length < 3) return ordens;
    List<OrdemModel> filtered = [];
    for (final ordem in ordens) {
      if (ordem.toString().toCompare.contains(search.toCompare)) {
        filtered.add(ordem);
      }
    }
    return filtered;
  }

  Future<void> onConfirm(_, OrdemModel? ordem, bool isFromOrder) async {
    try {
      onValid();
      if (form.isEdit) {
        final edit = form.toOrdemModel();
        await FirestoreClient.ordens.update(edit);
      } else {
        await FirestoreClient.ordens.add(form.toOrdemModel());
      }
      if (isFromOrder) {
        Navigator.pop(_, form.isEdit ? ordem : null);
      } else {
        pop(_);
      }
      NotificationService.showPositive(
          'Ordem ${form.isEdit ? 'Editada' : 'Adicionada'}', 'Operação realizada com sucesso',
          position: NotificationPosition.bottom);
    } catch (e) {
      NotificationService.showNegative('Erro', e.toString(), position: NotificationPosition.bottom);
    }
  }

  Future<void> onDelete(_, OrdemModel ordem) async {
    await FirestoreClient.ordens.delete(ordem);
    pop(_);
    NotificationService.showPositive('Ordem Excluida', 'Operação realizada com sucesso',
        position: NotificationPosition.bottom);
  }

  void onValid() {
    // if (form.nome.text.length < 2) {
    //   throw Exception('Nome deve conter no mínimo 3 caracteres');
    // }
  }

  //PEDIDO
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
        .map((e) => e.cliente)
        .toSet()
        .toList();
  }

  List<ObraModel> getObrasByClienteAndProduto(ClienteModel? cliente, ProdutoModel? produto) {
    if (cliente == null || produto == null) return [];
    return FirestoreClient.pedidos.data
        .where((e) =>
            e.cliente.id == cliente.id && e.produtos.map((e) => e.produto.id).contains(produto.id))
        .toList()
        .map((e) => e.obra)
        .toSet()
        .toList();
  }

  List<PedidoProdutoModel> getProduto(
      ClienteModel? cliente, ObraModel? obra, ProdutoModel? produto) {
    if (cliente == null || obra == null || produto == null) return [];
    final pedidos = FirestoreClient.pedidos.data.where((e) =>
        e.cliente.id == cliente.id &&
        e.obra.id == obra.id &&
        e.produtos.map((e) => e.produto.id).contains(produto.id));
    if (pedidos.isEmpty) return [];
    List<PedidoProdutoModel> pedidoProdutos = [];
    for (final pedido in pedidos) {
      pedidoProdutos.add(pedido.produtos.firstWhere((e) => e.produto.id == produto.id));
    }
    return pedidoProdutos
        .where((e) => form.produtos.map((e) => e.produto.id).contains(e.produto.id))
        .toList();
  }
}
