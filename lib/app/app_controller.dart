import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:programacao/app/core/models/service_model.dart';
import 'package:programacao/app/modules/usuario/usuario_controller.dart';

AppController appCtrl = AppController();

class AppController {
  static final AppController _instance = AppController._();

  AppController._();

  factory AppController() => _instance;

  final GlobalKey<NavigatorState> key = GlobalKey<NavigatorState>();
  BuildContext get context => key.currentState!.context;

  bool isInitialized = false;
  Future<void> onInit() async {
    if (isInitialized) return;
    isInitialized = true;
    FlutterNativeSplash.remove();
    await Service.initAplicationServices();
    await usuarioCtrl.getCurrentUser();
  }
}
