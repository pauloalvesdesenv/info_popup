import 'package:aco_plus/app/core/client/firestore/collections/cliente/cliente_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_model.dart';

enum RelatorioPedidoStatus { produzindo, pronto }

extension RelatorioPedidoStatusExt on RelatorioPedidoStatus {
  String get label {
    switch (this) {
      case RelatorioPedidoStatus.produzindo:
        return 'Produzindo';
      case RelatorioPedidoStatus.pronto:
        return 'Pronto';
    }
  }
}

class RelatorioPedidoViewModel {
  ClienteModel? cliente;
  RelatorioPedidoStatus? status;
  RelatorioPedidoModel? relatorio;
}

class RelatorioPedidoModel {
  final ClienteModel cliente;
  final RelatorioPedidoStatus status;
  final List<PedidoModel> pedidos;
  final DateTime createdAt = DateTime.now();

  RelatorioPedidoModel(this.cliente, this.status, this.pedidos);
}
