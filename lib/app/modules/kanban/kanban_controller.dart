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

  final AppStream<KanbanUtils> utilsStream = AppStream<KanbanUtils>();
  KanbanUtils get utils => utilsStream.value;

  void onInit() {
    final kanban = mountKanban();
    utilsStream.add(KanbanUtils(kanban: kanban));
    FirestoreClient.pedidos.fetch();
  }

  Map<StepModel, List<PedidoModel>> mountKanban() {
    final pedidos = FirestoreClient.pedidos.data;
    final steps = FirestoreClient.steps.data;
    final kanban = <StepModel, List<PedidoModel>>{};
    for (var step in steps) {
      final pedidosStep = pedidos.where((e) => e.step.id == step.id).toList();
      pedidosStep.sort((a, b) => a.index.compareTo(b.index));
      kanban[step] = pedidosStep;
    }
    return kanban;
  }

  void updateKanban() {
    utils.kanban = mountKanban();
    utilsStream.update();
  }

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
    _onMovePedido(pedido, step, index);
    await FirestoreClient.pedidos.update(pedido);
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

  void _onMovePedido(PedidoModel pedido, StepModel step, int index) {
    utils.kanban[pedido.step]!.remove(pedido);
    utils.kanban[step]!.insert(index, pedido);
    pedido.steps.add(PedidoStepModel(
        id: HashService.get, step: step, createdAt: DateTime.now()));
  }

  void _onRemovePedidoFromStep(String stepId, String pedidoId) {
    final step = utils.kanban.keys.firstWhere((e) => e.id == stepId);
    final pedido = utils.kanban[step]!.firstWhere((e) => e.id == pedidoId);
    utils.kanban[step]!.remove(pedido);
  }

  void _onAddPedidoFromStep(String stepId, String pedidoId) {
    final step = utils.kanban.keys.firstWhere((e) => e.id == stepId);
    final pedido = utils.kanban[step]!.firstWhere((e) => e.id == pedidoId);
    utils.kanban[step]!.remove(pedido);
  }


  PedidoModel getPedidoById(String id) =>
      FirestoreClient.pedidos.data.firstWhere((e) => e.id == id);

  List<PedidoModel> getPedidosByStep(StepModel step) =>
      FirestoreClient.pedidos.data.where((e) => e.id == step.id).toList();
}
