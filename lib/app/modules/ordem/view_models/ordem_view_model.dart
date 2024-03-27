import 'package:aco_plus/app/core/client/firestore/collections/cliente/cliente_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/ordem/models/ordem_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_produto_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/produto/produto_model.dart';
import 'package:aco_plus/app/core/client/firestore/firestore_client.dart';
import 'package:flutter/material.dart';

class OrdemUtils {
  final TextEditingController search = TextEditingController();
}

class OrdemCreateModel {
  final String id;
  ProdutoModel? produto;
  List<PedidoProdutoModel> produtos = [];

  late bool isEdit;

  OrdemCreateModel()
      : id = (FirestoreClient.ordens.data.length + 1).toString(),
        isEdit = false;

  OrdemCreateModel.edit(OrdemModel pedido)
      : id = pedido.id,
        isEdit = true;

  OrdemModel toOrdemModel() => OrdemModel(
        id: id,
        createdAt: DateTime.now(),
        produto: produto!,
        produtos: produtos.map((e) => e.copyWith()).toList(),
      );
}
