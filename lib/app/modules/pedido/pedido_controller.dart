import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_status_model.dart';
import 'package:aco_plus/app/core/client/firestore/firestore_client.dart';
import 'package:aco_plus/app/core/extensions/string_ext.dart';
import 'package:aco_plus/app/core/models/app_stream.dart';
import 'package:aco_plus/app/core/services/hash_service.dart';
import 'package:aco_plus/app/core/services/notification_service.dart';
import 'package:aco_plus/app/core/utils/global_resource.dart';
import 'package:aco_plus/app/modules/pedido/ui/pedido_status_bottom.dart';
import 'package:aco_plus/app/modules/pedido/view_models/pedido_view_model.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

final pedidoCtrl = PedidoController();
PedidoModel get pedido => pedidoCtrl.pedido;

class PedidoController {
  static final PedidoController _instance = PedidoController._();

  PedidoController._();

  factory PedidoController() => _instance;

  final AppStream<PedidoUtils> utilsStream =
      AppStream<PedidoUtils>.seed(PedidoUtils());
  PedidoUtils get utils => utilsStream.value;

  final AppStream<PedidoCreateModel> formStream =
      AppStream<PedidoCreateModel>();
  PedidoCreateModel get form => formStream.value;

  void onInitCreatePage(PedidoModel? pedido) {
    formStream.add(
        pedido != null ? PedidoCreateModel.edit(pedido) : PedidoCreateModel());
  }

  List<PedidoModel> getPedidoesFiltered(
      String search, List<PedidoModel> pedidos) {
    if (search.length < 3) return pedidos;
    List<PedidoModel> filtered = [];
    for (final pedido in pedidos) {
      if (pedido.toString().toCompare.contains(search.toCompare)) {
        filtered.add(pedido);
      }
    }
    return filtered;
  }

  Future<void> onConfirm(_, PedidoModel? pedido, bool isFromOrder) async {
    try {
      onValid();
      if (form.isEdit) {
        final edit = form.toPedidoModel();
        await FirestoreClient.pedidos.update(edit);
      } else {
        await FirestoreClient.pedidos.add(form.toPedidoModel());
      }
      if (isFromOrder) {
        Navigator.pop(_, form.isEdit ? pedido : null);
      } else {
        pop(_);
      }
      NotificationService.showPositive(
          'Pedido ${form.isEdit ? 'Editada' : 'Adicionada'}',
          'Operação realizada com sucesso',
          position: NotificationPosition.bottom);
    } catch (e) {
      NotificationService.showNegative('Erro', e.toString(),
          position: NotificationPosition.bottom);
    }
  }

  Future<void> onDelete(_, PedidoModel pedido) async {
    await FirestoreClient.pedidos.delete(pedido);
    pop(_);
    NotificationService.showPositive(
        'Pedido Excluida', 'Operação realizada com sucesso',
        position: NotificationPosition.bottom);
  }

  void onValid() {
    if (form.cliente == null) {
      throw Exception('Selecione o cliente do pedido');
    }
    if (form.tipo == null) {
      throw Exception('Selecione o tipo do pedido');
    }
    if (form.obra == null) {
      throw Exception('Selecione a obra do pedido');
    }
    if (form.produtos.isEmpty) {
      throw Exception('Adicione ao menos um produto ao pedido');
    }
  }

  //PEDIDO
  final AppStream<PedidoModel> pedidoStream = AppStream<PedidoModel>();
  PedidoModel get pedido => pedidoStream.value;

  void onInitPage(PedidoModel pedido) {
    pedidoStream.add(pedido);
  }

  void onChangePedidoStatus(PedidoModel pedido) async {
    final status = await showPedidoStatusBottom(pedido);
    if (status == null) return;
    if (pedido.statusess.last.status == status) return;
    pedido.statusess.add(PedidoStatusModel(
      id: HashService.get,
      status: status,
      createdAt: DateTime.now(),
    ));
    pedidoStream.update();
    await FirestoreClient.pedidos.update(pedido);
  }
}
