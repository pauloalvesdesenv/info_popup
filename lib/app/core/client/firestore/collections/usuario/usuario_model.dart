import 'dart:convert';

import 'package:aco_plus/app/core/client/firestore/collections/usuario/enums/usuario_role.dart';

class UsuarioModel {
  final String id;
  final String nome;
  final String email;
  final String senha;
  final UsuarioRole role;
  UsuarioModel({
    required this.id,
    required this.nome,
    required this.email,
    required this.senha,
    required this.role,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'senha': senha,
      'role': role.index,
    };
  }

  factory UsuarioModel.fromMap(Map<String, dynamic> map) {
    return UsuarioModel(
      id: map['id'] ?? '',
      nome: map['nome'] ?? '',
      email: map['email'] ?? '',
      senha: map['senha'] ?? '',
      role: map['role'] != null
          ? UsuarioRole.values[map['role']]
          : UsuarioRole.administrador,
    );
  }

  String toJson() => json.encode(toMap());

  factory UsuarioModel.fromJson(String source) =>
      UsuarioModel.fromMap(json.decode(source));
}
