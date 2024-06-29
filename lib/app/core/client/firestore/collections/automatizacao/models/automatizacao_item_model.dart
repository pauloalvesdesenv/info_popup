import 'dart:convert';

import 'package:aco_plus/app/core/client/firestore/collections/automatizacao/enums/automatizacao_enum.dart';
import 'package:aco_plus/app/core/client/firestore/collections/step/models/step_model.dart';

class AutomatizacaoItemModel {
  final String id;
  final AutomatizacaoItemType type;
  final DateTime createdAt;
  final StepModel step;
  AutomatizacaoItemModel({
    required this.id,
    required this.type,
    required this.createdAt,
    required this.step,
  });

  AutomatizacaoItemModel copyWith({
    String? id,
    AutomatizacaoItemType? type,
    DateTime? createdAt,
    StepModel? step,
  }) {
    return AutomatizacaoItemModel(
      id: id ?? this.id,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      step: step ?? this.step,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type.index,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'step': step.toMap(),
    };
  }

  factory AutomatizacaoItemModel.fromMap(Map<String, dynamic> map) {
    return AutomatizacaoItemModel(
      id: map['id'] ?? '',
      type: AutomatizacaoItemType.values[map['type']],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      step: StepModel.fromMap(map['step']),
    );
  }

  String toJson() => json.encode(toMap());

  factory AutomatizacaoItemModel.fromJson(String source) =>
      AutomatizacaoItemModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AutomatizacaoItemModel(id: $id, type: $type, createdAt: $createdAt, step: $step)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AutomatizacaoItemModel &&
        other.id == id &&
        other.type == type &&
        other.createdAt == createdAt &&
        other.step == step;
  }

  @override
  int get hashCode {
    return id.hashCode ^ type.hashCode ^ createdAt.hashCode ^ step.hashCode;
  }
}
