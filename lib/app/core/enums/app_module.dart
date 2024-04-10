import 'package:aco_plus/app/modules/cliente/ui/clientes_page.dart';
import 'package:aco_plus/app/modules/ordem/ui/ordens_page.dart';
import 'package:aco_plus/app/modules/pedido/ui/pedidos_page.dart';
import 'package:aco_plus/app/modules/relatorio/ui/relatorios_page.dart';
import 'package:flutter/material.dart';

enum AppModule {
  cliente,
  pedidos,
  ordens,
  relatorios,
}

extension AppModuleExt on AppModule {
  Widget get widget {
    switch (this) {
      case AppModule.cliente:
        return const ClientesPage();
      case AppModule.pedidos:
        return const PedidosPage();
      case AppModule.ordens:
        return const OrdensPage();
      case AppModule.relatorios:
        return const RelatoriosPage();
    }
  }

  IconData get icon {
    switch (this) {
      case AppModule.cliente:
        return Icons.group_outlined;
      case AppModule.pedidos:
        return Icons.shopping_cart_outlined;
      case AppModule.ordens:
        return Icons.work_outline;
      case AppModule.relatorios:
        return Icons.analytics_outlined;
    }
  }

  String get label {
    switch (this) {
      case AppModule.cliente:
        return 'Clientes';
      case AppModule.pedidos:
        return 'Pedidos';
      case AppModule.ordens:
        return 'Ordens';
      case AppModule.relatorios:
        return 'Relatórios';
    }
  }
}
