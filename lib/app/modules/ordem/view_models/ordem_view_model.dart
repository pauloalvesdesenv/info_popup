import 'dart:developer';

import 'package:aco_plus/app/core/client/firestore/collections/ordem/models/ordem_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_produto_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_produto_status_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/produto/produto_model.dart';
import 'package:aco_plus/app/core/client/firestore/firestore_client.dart';
import 'package:aco_plus/app/core/enums/sort_type.dart';
import 'package:aco_plus/app/core/models/text_controller.dart';

class OrdemUtils {
  final TextController search = TextController();
  List<PedidoProdutoStatus> status = [
    PedidoProdutoStatus.aguardandoProducao,
    PedidoProdutoStatus.produzindo
  ];
  ProdutoModel? produto;
}

class OrdemCreateModel {
  String id;
  ProdutoModel? produto;
  TextController cliente = TextController();
  List<PedidoProdutoModel> produtos = [];
  SortType sortType = SortType.alfabetic;
  SortOrder sortOrder = SortOrder.asc;
  bool isCreate = false;
  DateTime? createdAt;

  late bool isEdit;

  OrdemCreateModel()
      : id = (FirestoreClient.ordens.data.length + 1).toString(),
        isEdit = false;

  OrdemCreateModel.edit(OrdemModel pedido)
      : id = pedido.id,
        isEdit = true {
    createdAt = pedido.createdAt;
    produto = FirestoreClient.produtos.data
        .firstWhere((e) => e.id == pedido.produto.id);
    produtos = pedido.produtos
        .map((e) =>
            e.copyWith(isSelected: true, isAvailable: e.isAvailableToChanges))
        .toList();
  }

  OrdemModel toOrdemModel() {
    return OrdemModel(
        id: id,
        createdAt: createdAt ?? DateTime.now(),
        produto: produto!,
        produtos: produtos
            .map((e) => e.copyWith(statusess: [
                  ...e.statusess,
                  if (e.isSelected && !e.isAvailable)
                    PedidoProdutoStatusModel.create(
                        PedidoProdutoStatus.aguardandoProducao)
                ]))
            .toList());
  }
}
