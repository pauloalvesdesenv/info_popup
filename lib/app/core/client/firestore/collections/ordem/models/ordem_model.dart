import 'dart:convert';

import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_produto_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_produto_status_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/produto/produto_model.dart';

class OrdemModel {
  final String id;
  final ProdutoModel produto;
  final DateTime createdAt;
  DateTime? endAt;
  List<PedidoProdutoModel> produtos;

  double quantideTotal() {
    return produtos.fold(0, (previousValue, element) => previousValue + element.qtde);
  }

  double qtdeAguardando() {
    return produtos
        .where((e) => e.statusView.status == PedidoProdutoStatus.aguardandoProducao)
        .fold(0, (previousValue, element) => previousValue + element.qtde);
  }

  double qtdeProduzindo() {
    return produtos
        .where((e) => e.statusess.last.status == PedidoProdutoStatus.produzindo)
        .fold(0, (previousValue, element) => previousValue + element.qtde);
  }

  double qtdePronto() {
    return produtos
        .where((e) => e.statusess.last.status == PedidoProdutoStatus.pronto)
        .fold(0, (previousValue, element) => previousValue + element.qtde);
  }

  //  double getPrcntgPronto() {
  //   final pronto = getQtdePronto();
  //   final total = getQtdeTotal();
  //   if (total == 0) return 0;
  //   return pronto / total;
  // }

  double getPrcntgAguardando() {
    final aguardando = qtdeAguardando();
    final total = quantideTotal();
    if (total == 0) return 0;
    return aguardando / total;
  }

  double getPrcntgProduzindo() {
    final produzindo = qtdeProduzindo();
    final total = quantideTotal();
    if (total == 0) return 0;
    return produzindo / total;
  }

  double getPrcntgPronto() {
    final pronto = qtdePronto();
    final total = quantideTotal();
    if (total == 0) return 0;
    return pronto / total;
  }

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
      'produto': produto.toMap(),
      'produtos': produtos.map((x) => x.toMap()).toList(),
    };
  }

  factory OrdemModel.fromMap(Map<String, dynamic> map) {
    return OrdemModel(
      id: map['id'] ?? '',
      produto: ProdutoModel.fromMap(map['produto']),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      endAt: map['endAt'] != null ? DateTime.fromMillisecondsSinceEpoch(map['endAt']) : null,
      produtos:
          List<PedidoProdutoModel>.from(map['produtos']?.map((x) => PedidoProdutoModel.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory OrdemModel.fromJson(String source) => OrdemModel.fromMap(json.decode(source));
}
