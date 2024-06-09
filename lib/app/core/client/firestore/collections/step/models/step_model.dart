import 'dart:convert';

import 'package:aco_plus/app/core/client/firestore/collections/usuario/enums/usuario_role.dart';
import 'package:aco_plus/app/core/client/firestore/firestore_client.dart';
import 'package:aco_plus/app/modules/usuario/usuario_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class StepModel {
  final String id;
  final String name;
  final Color color;
  final List<UsuarioRole> moveRoles;
  final DateTime createdAt;
  final ScrollController scrollController = ScrollController();
  List<String> fromStepsIds;
  int index;

  List<StepModel> get fromSteps =>
      fromStepsIds.map((e) => FirestoreClient.steps.getById(e)).toList();

  bool get isEnable => moveRoles.contains(usuario.role);

  StepModel({
    required this.id,
    required this.name,
    required this.color,
    required this.fromStepsIds,
    required this.moveRoles,
    required this.createdAt,
    required this.index,
  });

  StepModel copyWith({
    String? id,
    String? name,
    Color? color,
    List<String>? fromStepsIds,
    List<String>? toStepsIds,
    List<UsuarioRole>? moveRoles,
    DateTime? createdAt,
    int? index,
  }) {
    return StepModel(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      fromStepsIds: fromStepsIds ?? this.fromStepsIds,
      moveRoles: moveRoles ?? this.moveRoles,
      createdAt: createdAt ?? this.createdAt,
      index: index ?? this.index,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'color': color.value,
      'fromStepsIds': fromStepsIds,
      'moveRoles': moveRoles.map((x) => x.index).toList(),
      'createdAt': createdAt.millisecondsSinceEpoch,
      'index': index
    };
  }

  factory StepModel.fromMap(Map<String, dynamic> map) {
    return StepModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      index: map['index'] ?? 0,
      color: Color(map['color']),
      fromStepsIds: map['fromStepsIds'] != null
          ? List<String>.from(map['fromStepsIds'])
          : <String>[],
      moveRoles: List<UsuarioRole>.from(
          map['moveRoles']?.map((x) => UsuarioRole.values[x])),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
    );
  }

  String toJson() => json.encode(toMap());

  factory StepModel.fromJson(String source) =>
      StepModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'StepModel(id: $id, name: $name, color: $color, fromSteps: $fromSteps, moveRoles: $moveRoles, createdAt: $createdAt)';
  }
}

class TesteClass {
  final List<String> fromStepsIds;
  TesteClass({
    required this.fromStepsIds,
  });

  TesteClass copyWith({
    List<String>? fromStepsIds,
  }) {
    return TesteClass(
      fromStepsIds: fromStepsIds ?? this.fromStepsIds,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fromStepsIds': fromStepsIds,
    };
  }

  factory TesteClass.fromMap(Map<String, dynamic> map) {
    return TesteClass(
      fromStepsIds: List<String>.from(map['fromStepsIds']),
    );
  }

  String toJson() => json.encode(toMap());

  factory TesteClass.fromJson(String source) =>
      TesteClass.fromMap(json.decode(source));

  @override
  String toString() => 'TesteClass(fromStepsIds: $fromStepsIds)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TesteClass && listEquals(other.fromStepsIds, fromStepsIds);
  }

  @override
  int get hashCode => fromStepsIds.hashCode;
}
