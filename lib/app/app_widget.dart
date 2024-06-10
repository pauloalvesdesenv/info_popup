import 'package:aco_plus/app/core/client/firestore/collections/usuario/models/usuario_model.dart';
import 'package:aco_plus/app/core/components/stream_out.dart';
import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:aco_plus/app/core/utils/app_theme.dart';
import 'package:aco_plus/app/modules/base/base_page.dart';
import 'package:aco_plus/app/modules/sign/ui/sign_up_page.dart';
import 'package:aco_plus/app/modules/usuario/usuario_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mentions/flutter_mentions.dart';
import 'package:overlay_support/overlay_support.dart';

import 'app_controller.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final AppController _appController = AppController();

  @override
  void initState() {
    _appController.onInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Portal(
      child: OverlaySupport(
          child: MaterialApp(
              color: AppColors.primaryMain,
              theme: AppTheme.theme,
              debugShowCheckedModeBanner: false,
              navigatorKey: _appController.key,
              title: 'AÇO+',
              home: StreamOutNull<UsuarioModel?>(
                stream: usuarioCtrl.usuarioStream.listen,
                child: (_, data) =>
                    data == null ? const SignUpPage() : const BasePage(),
              ))),
    );
  }
}
