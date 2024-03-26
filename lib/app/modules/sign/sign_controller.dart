import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:programacao/app/core/client/firestore/firestore_client.dart';
import 'package:programacao/app/core/enums/usuario_status.dart';
import 'package:programacao/app/core/models/app_stream.dart';
import 'package:programacao/app/core/services/notification_service.dart';
import 'package:programacao/app/core/utils/global_resource.dart';
import 'package:programacao/app/modules/sign/sign_view_model.dart';
import 'package:programacao/app/modules/usuario/usuario_controller.dart';
import 'package:string_validator/string_validator.dart';

final signCtrl = SignController();

class SignController {
  static final SignController _instance = SignController._();

  SignController._();

  factory SignController() => _instance;

  final GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();

  final AppStream<SignInCreateModel> formStream =
      AppStream<SignInCreateModel>();
  SignInCreateModel get form => formStream.value;

  void onClickLogin(String email, String senha) {
    try {
      final user = 
          FirestoreClient.usuarios.data
              .firstWhereOrNull((e) => e.email == email && e.senha == senha);
      if (user == null) throw Exception('Usuário não encontrado');
      if (user.status == UsuarioStatus.pendente) {
      throw Exception('Usuário em validação');
      }
      if (user.status == UsuarioStatus.desativado) {
        throw Exception('Usuário desativado');
      }
      usuarioCtrl.setCurrentUser(user);
    } catch (_) {
      NotificationService.showNegative('Erro', _.toString());
    }
  }

  Future<void> onConfirm(_) async {
    try {
      onValid();
      if (form.isTransportadora) {
        await FirestoreClient.transportadoras.add(form.toTransportadoraModel());
      } else {
        await FirestoreClient.usuarios.add(form.toUsuarioModel());
      }
      pop(_);
      NotificationService.showPositive('Usuário em revisão',
          'Retornaremos em breve com a confirmação do cadastro.',
          position: NotificationPosition.bottom);
    } catch (e) {
      NotificationService.showNegative(
          'Erro ao realizar operação', e.toString(),
          position: NotificationPosition.bottom);
    }
  }

  void onValid() {
    if (form.nome.text.length < 2) {
      throw Exception('Nome deve conter no mínimo 3 caracteres');
    }
    if (!isEmail(form.email.text)) {
      throw Exception('E-mail inválido');
    }
    if (form.telefone.text.length < 14) {
      throw Exception('Telefone inválido');
    }
    // if (form.funcao.text.isEmpty) {
    //   throw Exception('Defina o cargo/função do usuário');
    // }
    if (form.estados.isEmpty) {
      throw Exception('Selecione no mínimo um estado');
    }
    if (form.senha.text.length < 6) {
      throw Exception('Senha deve conter no mínimo 6 caracteres');
    }
  }
}
