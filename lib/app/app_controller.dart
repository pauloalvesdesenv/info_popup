import 'package:aco_plus/app/core/models/service_model.dart';
import 'package:aco_plus/app/modules/usuario/usuario_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

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
