import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:programacao/app/core/client/firestore/models/usuario_main_model.dart';
import 'package:programacao/app/core/components/stream_out.dart';
import 'package:programacao/app/core/utils/app_colors.dart';
import 'package:programacao/app/core/utils/app_theme.dart';
import 'package:programacao/app/modules/base/base_page.dart';
import 'package:programacao/app/modules/sign/ui/sign_up_page.dart';
import 'package:programacao/app/modules/usuario/usuario_controller.dart';

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
    return OverlaySupport(
        child: MaterialApp(
            color: AppColors.primaryMain,
            theme: AppTheme.theme,
            debugShowCheckedModeBanner: false,
            navigatorKey: _appController.key,
            title: 'Programação',
            home: StreamOutNull<UsuarioMainModel?>(
              stream: usuarioCtrl.usuarioStream.listen,
              child: (_, data) =>
                  data == null ? const SignUpPage() : const BasePage(),
            )));
  }
}
