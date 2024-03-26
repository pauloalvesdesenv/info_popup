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
  }
}
