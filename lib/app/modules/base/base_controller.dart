import 'package:flutter/material.dart';
import 'package:programacao/app/core/enums/app_module.dart';
import 'package:programacao/app/core/enums/usuario_role.dart';
import 'package:programacao/app/core/models/app_stream.dart';
import 'package:programacao/app/modules/usuario/usuario_controller.dart';

final baseCtrl = BaseController();

class BaseController {
  static final BaseController _instance = BaseController._();

  BaseController._();

  factory BaseController() => _instance;

  final GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();

  final AppStream<AppModule> moduleStream = AppStream<AppModule>();

  void onInit() {
    moduleStream.add(usuario.role.modules.first);
  }
}
