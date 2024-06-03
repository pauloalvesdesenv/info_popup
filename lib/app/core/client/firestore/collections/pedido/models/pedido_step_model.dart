import 'dart:convert';

import 'package:aco_plus/app/core/client/firestore/collections/step/models/step_model.dart';

class PedidoStepModel {
  final String id;
  final DateTime createdAt;
  StepModel step;
  
  PedidoStepModel({
    required this.id,
    required this.step,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'step': step.toMap(),
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory PedidoStepModel.fromMap(Map<String, dynamic> map) {
    return PedidoStepModel(
      id: map['id'],
      step: StepModel.fromMap(map['step']),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
    );
  }

  String toJson() => json.encode(toMap());

  factory PedidoStepModel.fromJson(String source) =>
      PedidoStepModel.fromMap(json.decode(source));

  PedidoStepModel copyWith({
    String? id,
    StepModel? step,
    DateTime? createdAt,
  }) {
    return PedidoStepModel(
      id: id ?? this.id,
      step: step ?? this.step,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
