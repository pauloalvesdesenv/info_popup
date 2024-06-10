import 'package:aco_plus/app/core/client/firestore/firestore_client.dart';
import 'package:aco_plus/app/core/services/push_notification_service.dart';
import 'package:aco_plus/app/modules/usuario/usuario_controller.dart';
import 'package:flutter/material.dart';
import 'package:aco_plus/app/core/enums/app_module.dart';
import 'package:aco_plus/app/core/models/app_stream.dart';

final baseCtrl = BaseController();

class BaseController {
  static final BaseController _instance = BaseController._();

  BaseController._();

  factory BaseController() => _instance;

  final GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();

  final AppStream<AppModule> moduleStream = AppStream<AppModule>();

  void onInit() {
    moduleStream.add(AppModule.values.first);
    onUpdateUserDeviceToken();
  }

  Future<void> onUpdateUserDeviceToken() async {
    final token = await getDeviceToken();
    if (token != null && usuario.deviceTokens.contains(token)) return;
    usuario.deviceTokens.add(token!);
    FirestoreClient.usuarios.update(usuario);
  }
}
