import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/step/models/step_model.dart';
import 'package:flutter/material.dart';

enum KanbanViewMode {
  calendar,
  kanban,
}

class KanbanUtils {
  KanbanViewMode view = KanbanViewMode.calendar;
  Map<StepModel, List<PedidoModel>> kanban;
  Map<String, List<PedidoModel>> calendar;
  final ScrollController scroll = ScrollController();
  PedidoModel? pedido;
  bool get isPedidoSelected => pedido != null;

  KanbanUtils({required this.kanban, required this.calendar});
}
