import 'package:aco_plus/app/core/models/app_stream.dart';
import 'package:aco_plus/app/modules/kanban/kanban_view_model.dart';

final kanbanCtrl = StepController();

class StepController {
  static final StepController _instance = StepController._();

  StepController._();

  factory StepController() => _instance;

  final AppStream<KanbanUtils> utilsStream =
      AppStream<KanbanUtils>.seed(KanbanUtils());
  KanbanUtils get utils => utilsStream.value;
}
