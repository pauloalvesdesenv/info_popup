import 'dart:convert';

import 'package:aco_plus/app/core/client/firestore/collections/cliente/cliente_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_produto_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_produto_status_model.dart';

class   PedidoModel {
  final String id;
  final DateTime createdAt;
  final ClienteModel cliente;
  final ObraModel obra;
  final List<PedidoProdutoModel> produtos;
  PedidoModel({
    required this.id,
    required this.createdAt,
    required this.cliente,
    required this.obra,
    required this.produtos,
  });

  List<PedidoProdutoStatus> get statusess {
    List<PedidoProdutoStatus> statusess = [];
    for (var element in produtos) {
      statusess.add(element.statusess.last.status);
    }
    return statusess.toSet().toList();
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'cliente': cliente.toMap(),
      'obra': obra.toMap(),
      'produtos': produtos.map((x) => x.toMap()).toList(),
    };
  }

  factory PedidoModel.fromMap(Map<String, dynamic> map) {
    return PedidoModel(
      id: map['id'] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      cliente: ClienteModel.fromMap(map['cliente']),
      obra: ObraModel.fromMap(map['obra']),
      produtos:
          List<PedidoProdutoModel>.from(map['produtos']?.map((x) => PedidoProdutoModel.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory PedidoModel.fromJson(String source) => PedidoModel.fromMap(json.decode(source));
}
