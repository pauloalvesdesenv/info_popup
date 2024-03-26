import 'package:flutter/material.dart';
import 'package:programacao/app/core/components/app_drawer.dart';
import 'package:programacao/app/core/components/app_scaffold.dart';
import 'package:programacao/app/core/components/stream_out.dart';
import 'package:programacao/app/core/enums/app_module.dart';
import 'package:programacao/app/modules/base/base_controller.dart';

class BasePage extends StatefulWidget {
  const BasePage({super.key});

  @override
  State<BasePage> createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  @override
  void initState() {
    baseCtrl.onInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      scaffoldKey: baseCtrl.key,
      drawer: const AppDrawer(),
      body: StreamOut(
        stream: baseCtrl.moduleStream.listen,
        child: (_, __) => __.widget,
      ),
    );
  }
}
