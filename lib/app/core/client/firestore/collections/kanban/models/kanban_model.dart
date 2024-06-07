import 'dart:convert';

import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/step/models/step_model.dart';
import 'package:aco_plus/app/core/client/firestore/firestore_client.dart';

class KanbanModel {
  final String id;
  final Map<StepModel, List<PedidoModel>> kanban;

  

  KanbanModel({
    required this.id,
    required this.kanban,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'kanban': json.encode(kanban.toMap()),
    };
  }

  factory KanbanModel.fromMap(Map<String, dynamic> map) {
    return KanbanModel(
      id: map['id'] ?? '',
      kanban: (map['kanban'] as String).fromMap(),
    );
  }

  String toJson() => json.encode(toMap());

  factory KanbanModel.fromJson(String source) =>
      KanbanModel.fromMap(json.decode(source));
}

extension MapStepListPedidoExt on Map<StepModel, List<PedidoModel>> {
  Map<String, List<String>> toMap() {
    return {
      for (var key in keys) key.id: this[key]!.map((e) => e.id).toList(),
    };
  }
}

extension StringExt on String {
  Map<StepModel, List<PedidoModel>> fromMap() {

    final mapper = json.decode(this) as Map<String, dynamic>;
    Map<StepModel, List<PedidoModel>> kanban = {};
    for (var stepId in mapper.keys.toList()) {
      final step = FirestoreClient.steps.getById(stepId);
      final pedidos = (mapper[stepId]! as List)
          .map((e) => FirestoreClient.pedidos.getById(e))
          .toList();
      kanban[step] = pedidos;
    }
    return kanban;
  }
}
