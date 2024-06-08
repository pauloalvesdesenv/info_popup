import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/step/models/step_model.dart';
import 'package:flutter/material.dart';

class KanbanUtils {
  Map<StepModel, List<PedidoModel>> kanban;
  final ScrollController scroll = ScrollController();
  PedidoModel? pedido;
  bool get isPedidoSelected => pedido != null;

  KanbanUtils({required this.kanban});
}
