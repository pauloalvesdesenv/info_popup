import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

enum AppModule { cliente }

extension AppModuleExt on AppModule {
  Widget get widget {
    switch (this) {
      case AppModule.cliente:
        return Center(
          child: Text(
            '🔨 Em contrução',
            style: AppCss.mediumRegular.setColor(AppColors.primaryMain),
          ),
        );
    }
  }

  IconData get icon {
    switch (this) {
      case AppModule.cliente:
        return Symbols.person_outline;
    }
  }

  String get label {
    switch (this) {
      case AppModule.cliente:
        return 'Clientes';
    }
  }
}
