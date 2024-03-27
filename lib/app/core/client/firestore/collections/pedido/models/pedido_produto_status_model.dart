import 'dart:convert';

import 'package:flutter/material.dart';

enum PedidoProdutoStatus { aguardandoProducao, produzindo, pronto }

extension PedidoProdutoStatusExt on PedidoProdutoStatus {
  String get label {
    switch (this) {
      case PedidoProdutoStatus.aguardandoProducao:
        return 'Aguardando Produção';
      case PedidoProdutoStatus.produzindo:
        return 'Produzindo';
      case PedidoProdutoStatus.pronto:
        return 'Pronto';
    }
  }

  Color get color {
    switch (this) {
      case PedidoProdutoStatus.aguardandoProducao:
        return Colors.grey;
      case PedidoProdutoStatus.produzindo:
        return Colors.orange;
      case PedidoProdutoStatus.pronto:
        return Colors.green;
    }
  }
}

class PedidoProdutoStatusModel {
  final String id;
  final PedidoProdutoStatus status;
  final DateTime createdAt;
  PedidoProdutoStatusModel({
    required this.id,
    required this.status,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'status': status.index,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory PedidoProdutoStatusModel.fromMap(Map<String, dynamic> map) {
    return PedidoProdutoStatusModel(
      id: map['id'] ?? '',
      status: PedidoProdutoStatus.values[map['status']],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
    );
  }

  String toJson() => json.encode(toMap());

  factory PedidoProdutoStatusModel.fromJson(String source) =>
      PedidoProdutoStatusModel.fromMap(json.decode(source));
}
