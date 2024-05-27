import 'package:aco_plus/app/core/client/firestore/collections/cliente/cliente_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_produto_status_model.dart';
import 'package:aco_plus/app/core/enums/sort_type.dart';

enum RelatorioPedidoTipo { pedidos, totais, pedidosTotais }

extension RelatorioTipoStatusExtension on RelatorioPedidoTipo {
  String get label {
    switch (this) {
      case RelatorioPedidoTipo.pedidos:
        return 'Pedidos';
      case RelatorioPedidoTipo.totais:
        return 'Totais';
      case RelatorioPedidoTipo.pedidosTotais:
        return 'Pedidos e Totais';
    }
  }
}

class RelatorioPedidoViewModel {
  ClienteModel? cliente;
  List<PedidoProdutoStatus> status = PedidoProdutoStatus.values;
  RelatorioPedidoModel? relatorio;
  late SortType sortType;
  SortOrder sortOrder = SortOrder.asc;

  List<SortType> sortTypes = [
    SortType.localizator,
    SortType.deliveryAt,
    SortType.client
  ];

  RelatorioPedidoViewModel() {
    sortType = sortTypes.first;
  }
}

class RelatorioPedidoModel {
  final ClienteModel? cliente;
  final List<PedidoProdutoStatus> status;
  final List<PedidoModel> pedidos;
  final DateTime createdAt = DateTime.now();
  RelatorioPedidoTipo tipo = RelatorioPedidoTipo.pedidos;

  RelatorioPedidoModel(this.cliente, this.status, this.pedidos);
}
