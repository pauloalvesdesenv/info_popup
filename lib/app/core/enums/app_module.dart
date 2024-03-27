import 'package:aco_plus/app/modules/cliente/ui/clientes_page.dart';
import 'package:aco_plus/app/modules/pedido/ui/pedidos_page.dart';
import 'package:flutter/material.dart';

enum AppModule { cliente, pedidos }

extension AppModuleExt on AppModule {
  Widget get widget {
    switch (this) {
      case AppModule.cliente:
        return const ClientesPage();
      case AppModule.pedidos:
        return const PedidosPage();
    }
  }

  IconData get icon {
    switch (this) {
      case AppModule.cliente:
        return Icons.group_outlined;
      case AppModule.pedidos:
        return Icons.shopping_cart_outlined;
    }
  }

  String get label {
    switch (this) {
      case AppModule.cliente:
        return 'Clientes';
      case AppModule.pedidos:
        return 'Pedidos';
    }
  }
}
