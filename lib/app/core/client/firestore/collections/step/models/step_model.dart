import 'dart:convert';

import 'package:aco_plus/app/core/client/firestore/collections/usuario/enums/usuario_role.dart';
import 'package:aco_plus/app/core/client/firestore/firestore_client.dart';
import 'package:flutter/material.dart';

class StepModel {
  final String id;
  final String name;
  final Color color;
  final List<StepModel> fromSteps;
  final List<StepModel> toSteps;
  final List<UsuarioRole> moveRoles;
  final DateTime createdAt;
  final ScrollController scrollController = ScrollController();

  StepModel({
    required this.id,
    required this.name,
    required this.color,
    required this.fromSteps,
    required this.toSteps,
    required this.moveRoles,
    required this.createdAt,
  });

  StepModel copyWith({
    String? id,
    String? name,
    Color? color,
    List<StepModel>? fromSteps,
    List<StepModel>? toSteps,
    List<UsuarioRole>? moveRoles,
    DateTime? createdAt,
  }) {
    return StepModel(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      fromSteps: fromSteps ?? this.fromSteps,
      toSteps: toSteps ?? this.toSteps,
      moveRoles: moveRoles ?? this.moveRoles,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'color': color.value,
      'fromSteps': fromSteps.map((x) => x.toMap()).toList(),
      'toSteps': toSteps.map((x) => x.id).toList(),
      'moveRoles': moveRoles.map((x) => x.index).toList(),
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory StepModel.fromMap(Map<String, dynamic> map) {
    return StepModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      color: Color(map['color']),
      fromSteps: List<StepModel>.from(
          map['fromSteps']?.map((x) => StepModel.fromMap(x))),
      toSteps: List<StepModel>.from(
          map['toSteps']?.map((x) => FirestoreClient.steps.getById(x))),
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
    return 'StepModel(id: $id, name: $name, color: $color, fromSteps: $fromSteps, toSteps: $toSteps, moveRoles: $moveRoles, createdAt: $createdAt)';
  }
}
