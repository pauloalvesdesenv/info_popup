import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:programacao/app/modules/dashboard/ui/dashboard_page.dart';
import 'package:programacao/app/modules/fornecedor/ui/fornecedores_page.dart';
import 'package:programacao/app/modules/motorista/ui/motoristas_page.dart';
import 'package:programacao/app/modules/ordem/ui/ordens_page.dart';
import 'package:programacao/app/modules/transportadora/ui/transportadora_page.dart';
import 'package:programacao/app/modules/usuario/ui/usuarios_page.dart';

enum AppModule {
  dashboard,
  usuario,
  transportadora,
  ordem,
  fornecedor,
  motorista,
}

extension AppModuleExt on AppModule {
  Widget get widget {
    switch (this) {
      case AppModule.dashboard:
        return const DashboardPage();
      case AppModule.usuario:
        return const UsuariosPage();
      case AppModule.transportadora:
        return const TransportadorasPage();
      case AppModule.ordem:
        return const OrdensPage();
      case AppModule.fornecedor:
        return const FornecedoresPage();
      case AppModule.motorista:
        return const MotoristasPage();
    }
  }

  IconData get icon {
    switch (this) {
      case AppModule.dashboard:
        return Icons.dashboard_outlined;
      case AppModule.usuario:
        return Icons.group_outlined;
      case AppModule.transportadora:
        return Icons.local_shipping_outlined;
      case AppModule.ordem:
        return Icons.list_alt;
      case AppModule.fornecedor:
        return Symbols.package_2;
      case AppModule.motorista:
        return Symbols.person_apron;
    }
  }

  String get label {
    switch (this) {
      case AppModule.dashboard:
        return 'Dashboard';
      case AppModule.usuario:
        return 'Usuários';
      case AppModule.transportadora:
        return 'Transportadoras';
      case AppModule.ordem:
        return 'Ordens';
      case AppModule.fornecedor:
        return 'Fornecedores';
      case AppModule.motorista:
        return 'Motoristas';
    }
  }
}
