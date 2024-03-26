import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:programacao/app/core/client/firestore/collections/motorista/motorista_model.dart';
import 'package:programacao/app/core/client/firestore/collections/transportadora/transportadora_model.dart';
import 'package:programacao/app/core/client/firestore/collections/usuario/usuario_model.dart';
import 'package:programacao/app/core/enums/country_states.dart';
import 'package:programacao/app/core/enums/usuario_role.dart';
import 'package:programacao/app/core/enums/usuario_status.dart';
import 'package:programacao/app/core/services/hash_service.dart';
import 'package:programacao/app/modules/veiculo/veiculo_model.dart';

class SignInCreateModel {
  final String id;
  TextEditingController nome = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController funcao = TextEditingController();
  TextEditingController telefone =
      MaskedTextController(mask: '(00) 00000-0000');
  TextEditingController cnpj = MaskedTextController(mask: '00.000.000/0000-00');
  List<CountryState> estados = [];
  UsuarioRole? role;
  TextEditingController senha = TextEditingController();
  List<MotoristaModel> motoristas = [];
  List<VeiculoModel> veiculos = [];

  SignInCreateModel() : id = HashService.get;

  bool get isTransportadora => role == UsuarioRole.transportadora;

  TransportadoraModel toTransportadoraModel() {
    return TransportadoraModel(
      id: id,
      nome: nome.text,
      email: email.text,
      telefone: telefone.text,
      cnpj: cnpj.text,
      role: role!,
      estados: estados,
      senha: senha.text,
      motoristas: motoristas,
      veiculos: veiculos,
      status: UsuarioStatus.pendente,
    );
  }

  UsuarioModel toUsuarioModel() {
    return UsuarioModel(
      id: id,
      nome: nome.text,
      email: email.text,
      telefone: telefone.text,
      role: role!,
      funcao: funcao.text,
      estados: estados,
      senha: senha.text,
      status: UsuarioStatus.pendente,
    );
  }
}
