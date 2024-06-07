import 'package:aco_plus/app/core/client/firestore/collections/kanban/models/kanban_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_step_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/step/models/step_model.dart';
import 'package:aco_plus/app/core/client/firestore/firestore_client.dart';
import 'package:aco_plus/app/core/models/app_stream.dart';
import 'package:aco_plus/app/core/services/hash_service.dart';
import 'package:aco_plus/app/core/services/notification_service.dart';
import 'package:aco_plus/app/modules/kanban/kanban_view_model.dart';
import 'package:flutter/material.dart';

final kanbanCtrl = StepController();

class StepController {
  static final StepController _instance = StepController._();

  StepController._();

  factory StepController() => _instance;

  KanbanModel get kanban => FirestoreClient.kanban.data;

  final AppStream<KanbanUtils> utilsStream =
      AppStream<KanbanUtils>.seed(KanbanUtils());
  KanbanUtils get utils => utilsStream.value;

  void setPedido(PedidoModel? pedido) {
    utils.pedido = pedido;
    utilsStream.update();
  }

  void onAccept(
    DragTargetDetails<PedidoModel> details,
    StepModel step,
    List<PedidoModel> pedidos,
    int index,
  ) async {
    // if (!_onWillAccept(details, step)) return;
    final pedido = details.data;
    _onMovePedido(pedidos, pedido, step, index);
    FirestoreClient.kanban.dataStream.update();
    await FirestoreClient.pedidos.update(pedido);
    FirestoreClient.kanban.update();
    // PedidoModel pedido = getPedidoById(details.data.id);
    // if (pedido.step.id != step.id) _onAddStep(pedido, step);
    // pedido =
    //     FirestoreClient.pedidos.data.firstWhere((e) => e.id == details.data.id);
    // _onMovePedido(pedidos, pedido, step, index);
    // FirestoreClient.pedidos.dataStream.update();
  }

  bool _onWillAccept(DragTargetDetails<PedidoModel> details, StepModel step) {
    final accept =
        step.fromSteps.map((e) => e.id).contains(details.data.step.id);
    if (!accept) {
      NotificationService.showNegative(
          'Operação não permitida', 'Você não mover para esta etapa.');
    }
    return accept;
  }

  void _onAddStep(PedidoModel pedido, StepModel step) {
    pedido.steps.add(PedidoStepModel(
        id: HashService.get, step: step, createdAt: DateTime.now()));
    FirestoreClient.pedidos.dataStream.update();
  }

  void _onMovePedido(List<PedidoModel> pedidos, PedidoModel pedido,
      StepModel step, int index) {
    kanban.kanban[pedido.step]!.removeWhere((e) => e.id == pedido.id);
    kanban.kanban[step]!.insert(index, pedido);
    pedido.steps.add(PedidoStepModel(
        id: HashService.get, step: step, createdAt: DateTime.now()));
  }

  PedidoModel getPedidoById(String id) =>
      FirestoreClient.pedidos.data.firstWhere((e) => e.id == id);

  List<PedidoModel> getPedidosByStep(StepModel step) =>
      FirestoreClient.pedidos.data.where((e) => e.id == step.id).toList();

  Future<void> onAddPedido(String stepId, String pedidoId) async {
    final pedido = FirestoreClient.pedidos.getById(pedidoId);
    final step = FirestoreClient.steps.getById(stepId);
    kanban.kanban[step]!.add(pedido);
    await FirestoreClient.kanban.update();
  }
}
