import 'dart:convert';

import 'package:programacao/app/core/client/firestore/models/usuario_main_model.dart';
import 'package:programacao/app/core/enums/country_states.dart';
import 'package:programacao/app/core/enums/usuario_role.dart';
import 'package:programacao/app/core/enums/usuario_status.dart';

class UsuarioModel extends UsuarioMainModel {
  final String funcao;

  UsuarioModel({
    required String id,
    required String nome,
    required String email,
    required String telefone,
    required UsuarioRole role,
    required this.funcao,
    required List<CountryState> estados,
    required UsuarioStatus status,
    required String senha,
  }) : super(
          id: id,
          nome: nome,
          email: email,
          telefone: telefone,
          role: role,
          estados: estados,
          status: status,
          senha: senha,
        );

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'telefone': telefone,
      'role': role.index,
      'funcao': funcao,
      'estados': estados.map((e) => e.index).toList(),
      'status': status.index,
      'senha': senha,
    };
  }

  factory UsuarioModel.fromMap(Map<String, dynamic> map) {
    return UsuarioModel(
      id: map['id'] ?? '',
      nome: map['nome'] ?? '',
      email: map['email'] ?? '',
      telefone: map['telefone'] ?? '',
      role: UsuarioRole.values[map['role']],
      funcao: map['funcao'] ?? '',
      estados:
          (map['estados'] as List).map((e) => CountryState.values[e]).toList(),
      status: UsuarioStatus.values[map['status']],
      senha: map['senha'] ?? '',
    );
  }

  @override
  String toJson() => json.encode(toMap());

  factory UsuarioModel.fromJson(String source) =>
      UsuarioModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UsuarioModel(id: $id, nome: $nome, email: $email, telefone: $telefone, role: $role, funcao: $funcao, estados: $estados)';
  }
}
