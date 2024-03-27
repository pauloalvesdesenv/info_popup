import 'dart:convert';

import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_produto_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/produto/produto_model.dart';

class OrdemModel {
  final String id;
  final ProdutoModel produto;
  final DateTime createdAt;
  DateTime? endAt;
  final List<PedidoProdutoModel> produtos;

  OrdemModel({
    required this.id,
    required this.createdAt,
    required this.produto,
    required this.produtos,
    this.endAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'endAt': endAt?.millisecondsSinceEpoch,
      'produtos': produtos.map((x) => x.toMap()).toList(),
    };
  }

  factory OrdemModel.fromMap(Map<String, dynamic> map) {
    return OrdemModel(
      id: map['id'] ?? '',
      produto: ProdutoModel.fromMap(map['produto']),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      endAt: DateTime.fromMillisecondsSinceEpoch(map['endAt']),
      produtos:
          List<PedidoProdutoModel>.from(map['produtos']?.map((x) => PedidoProdutoModel.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory OrdemModel.fromJson(String source) => OrdemModel.fromMap(json.decode(source));
}
