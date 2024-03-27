import 'dart:convert';

import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_produto_status_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/produto/produto_model.dart';

class PedidoProdutoModel {
  final String id;
  final String clienteId;
  final ProdutoModel produto;
  final List<PedidoProdutoStatusModel> statusess;
  final double qtde;

  PedidoProdutoModel({
    required this.id,
    required this.clienteId,
    required this.produto,
    required this.statusess,
    required this.qtde,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'clienteId': clienteId,
      'produto': produto.toMap(),
      'statusess': statusess.map((x) => x.toMap()).toList(),
      'qtde': qtde,
    };
  }

  factory PedidoProdutoModel.fromMap(Map<String, dynamic> map) {
    return PedidoProdutoModel(
      id: map['id'] ?? '',
      clienteId: map['clienteId'] ?? '',
      produto: ProdutoModel.fromMap(map['produto']),
      statusess: List<PedidoProdutoStatusModel>.from(
          map['statusess']?.map((x) => PedidoProdutoStatusModel.fromMap(x))),
      qtde: map['qtde'] ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory PedidoProdutoModel.fromJson(String source) =>
      PedidoProdutoModel.fromMap(json.decode(source));

  PedidoProdutoModel copyWith({
    String? id,
    String? clienteId,
    ProdutoModel? produto,
    List<PedidoProdutoStatusModel>? statusess,
    double? qtde,
  }) {
    return PedidoProdutoModel(
      id: id ?? this.id,
      clienteId: clienteId ?? this.clienteId,
      produto: produto ?? this.produto,
      statusess: statusess ?? this.statusess,
      qtde: qtde ?? this.qtde,
    );
  }
}
