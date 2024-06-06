import 'dart:convert';

import 'package:aco_plus/app/core/client/firestore/collections/step/models/step_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/usuario/enums/usuario_role.dart';
import 'package:aco_plus/app/core/client/firestore/collections/usuario/models/usuario_permission_model.dart';

class UsuarioModel {
  final String id;
  final String nome;
  final String email;
  final String senha;
  final UsuarioRole role;
  final UserPermissionModel permission;
  final List<StepModel> steps;

  UsuarioModel({
    required this.id,
    required this.nome,
    required this.email,
    required this.senha,
    required this.role,
    required this.permission,
    required this.steps,
  });

  UsuarioModel copyWith({
    String? id,
    String? nome,
    String? email,
    String? senha,
    UsuarioRole? role,
    UserPermissionModel? permission,
    List<StepModel>? steps,
  }) {
    return UsuarioModel(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      email: email ?? this.email,
      senha: senha ?? this.senha,
      role: role ?? this.role,
      permission: permission ?? this.permission,
      steps: steps ?? this.steps,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'senha': senha,
      'role': role.index,
      'permission': permission.toMap(),
      'steps': steps.map((x) => x.toMap()).toList(),
    };
  }

  factory UsuarioModel.fromMap(Map<String, dynamic> map) {
    return UsuarioModel(
        id: map['id'] ?? '',
        nome: map['nome'] ?? '',
        email: map['email'] ?? '',
        senha: map['senha'] ?? '',
        role: UsuarioRole.values[map['role']],
        permission: map['permission'] != null
            ? UserPermissionModel.fromMap(map['permission'])
            : UserPermissionModel.all(),
        steps: []);
  }

  String toJson() => json.encode(toMap());

  factory UsuarioModel.fromJson(String source) =>
      UsuarioModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UsuarioModel(id: $id, nome: $nome, email: $email, senha: $senha, role: $role, permission: $permission)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UsuarioModel &&
        other.id == id &&
        other.nome == nome &&
        other.email == email &&
        other.senha == senha &&
        other.role == role &&
        other.permission == permission;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        nome.hashCode ^
        email.hashCode ^
        senha.hashCode ^
        role.hashCode ^
        permission.hashCode;
  }
}
