import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/step/models/step_model.dart';
import 'package:aco_plus/app/core/client/firestore/firestore_client.dart';
import 'package:aco_plus/app/core/models/app_stream.dart';
import 'package:aco_plus/app/core/services/notification_service.dart';
import 'package:aco_plus/app/modules/kanban/kanban_view_model.dart';
import 'package:aco_plus/app/modules/usuario/usuario_controller.dart';

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
    StepModel step,
    PedidoModel pedido,
    int index,
  ) async {
    if (!onWillAccept(pedido, step)) return;
    _onMovePedido(pedido, step, index);
    _onAddStep(pedido, step);
    utilsStream.update();
  }

  bool onWillAccept(PedidoModel pedido, StepModel step) {
    final isStepAvailable =
        step.fromSteps.map((e) => e.id).contains(pedido.step.id);
    if (!isStepAvailable) {
      NotificationService.showNegative(
          'Operação não permitida', 'Etapa não aceita esta operação');
      return false;
    }
    final isUserAvailable = step.moveRoles.contains(usuario.role);
    if (!isUserAvailable) {
      NotificationService.showNegative('Operação não permitida',
          'Usuário não tem permissão para alterar essa etapa');
      return false;
    }
    return true;
  }

  void _onAddStep(PedidoModel pedido, StepModel step) {
    pedido.addStep(step);
    FirestoreClient.pedidos.dataStream.update();
    FirestoreClient.pedidos.update(pedido);
  }

  void _onMovePedido(PedidoModel pedido, StepModel step, int index) {
    _onAddPedidoFromStep(step.id, index,
        pedido: _onRemovePedidoFromStep(pedido.step.id, pedido.id));
  }

  PedidoModel _onRemovePedidoFromStep(String stepId, String pedidoId) {
    final key = utils.kanban.keys.firstWhere((e) => e.id == stepId);
    final pedido = utils.kanban[key]!.firstWhere((e) => e.id == pedidoId);
    utils.kanban[key]!.remove(pedido);
    return pedido;
  }

  void _onAddPedidoFromStep(String stepId, int index,
      {required PedidoModel pedido}) {
    final key = utils.kanban.keys.firstWhere((e) => e.id == stepId);
    utils.kanban[key]!.insert(index, pedido);
  }
}
