import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/step/models/step_model.dart';
import 'package:aco_plus/app/core/client/firestore/firestore_client.dart';
import 'package:aco_plus/app/core/models/app_stream.dart';
import 'package:aco_plus/app/core/services/notification_service.dart';
import 'package:aco_plus/app/modules/kanban/kanban_view_model.dart';
import 'package:aco_plus/app/modules/usuario/usuario_controller.dart';
import 'package:intl/intl.dart';

final kanbanCtrl = StepController();

class StepController {
  static final StepController _instance = StepController._();

  StepController._();

  factory StepController() => _instance;

  final AppStream<KanbanUtils> utilsStream = AppStream<KanbanUtils>();
  KanbanUtils get utils => utilsStream.value;

  Future<void> onInit() async {
    await FirestoreClient.pedidos.fetch();
    final kanban = mountKanban();
    final calendar = _mountCalendar();
    utilsStream.add(KanbanUtils(kanban: kanban, calendar: calendar));
  }

  void onMount() async {
    final kanban = mountKanban();
    final calendar = _mountCalendar();
    utils.calendar = calendar;
    utils.kanban = kanban;
    utilsStream.update();
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

  Future<void> onMountCalendar() async {
    await FirestoreClient.pedidos.fetch();
    utils.calendar = _mountCalendar();
    utilsStream.update();
  }

  Map<String, List<PedidoModel>> _mountCalendar() {
    final calendar = <String, List<PedidoModel>>{};
    final keys = FirestoreClient.pedidos.data
        .where((e) => e.deliveryAt != null)
        .map((e) => e.deliveryAt!)
        .toSet();
    for (DateTime key in keys) {
      calendar[DateFormat('dd/MM/yyyy').format(key)] = FirestoreClient
          .pedidos.data
          .where((e) => e.deliveryAt == key)
          .toList();
    }
    return calendar;
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
    if (pedido.step.id != step.id) {
      final isStepAvailable =
          step.fromSteps.map((e) => e.id).contains(pedido.step.id);
      if (!isStepAvailable) {
        NotificationService.showNegative(
            'Operação não permitida', 'Etapa não aceita esta operação');
        return false;
      }
    }
    final isUserAvailable = step.moveRoles.contains(usuario.role) &&
        pedido.step.moveRoles.contains(usuario.role);
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
