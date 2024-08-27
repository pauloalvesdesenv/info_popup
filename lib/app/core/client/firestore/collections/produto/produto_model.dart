import 'dart:convert';

import 'package:aco_plus/app/core/services/hash_service.dart';

class ProdutoModel {
  final String id;
  final String nome;
  final String descricao;

  factory ProdutoModel.empty() => ProdutoModel(id: HashService.get, nome: 'Produto não encontrado', descricao: 'Este produto não foi encontrado no sistema');

  String get descricaoReplaced => descricao.replaceAll('mm', '').replaceAll('.0', '');

  double get number => double.parse(descricao.substring(0, descricao.length - 2));

  ProdutoModel({
    required this.id,
    required this.nome,
    required this.descricao,
  });

  String get label => '$nome - $descricao';

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'descricao': descricao,
    };
  }

  factory ProdutoModel.fromMap(Map<String, dynamic> map) {
    return ProdutoModel(
      id: map['id'] ?? '',
      nome: map['nome'] ?? '',
      descricao: map['descricao'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ProdutoModel.fromJson(String source) => ProdutoModel.fromMap(json.decode(source));

  ProdutoModel copyWith({
    String? id,
    String? nome,
    String? descricao,
  }) {
    return ProdutoModel(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      descricao: descricao ?? this.descricao,
    );
  }
}
