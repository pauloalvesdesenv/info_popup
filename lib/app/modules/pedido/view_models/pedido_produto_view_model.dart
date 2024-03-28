import 'package:aco_plus/app/core/client/firestore/collections/cliente/cliente_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_produto_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_produto_status_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/produto/produto_model.dart';
import 'package:aco_plus/app/core/extensions/text_controller_ext.dart';
import 'package:aco_plus/app/core/services/hash_service.dart';
import 'package:flutter/material.dart';

class PedidoProdutoCreateModel {
  final String id;
  ProdutoModel? produtoModel;
  TextEditingController qtde = TextEditingController();

  bool get isEnable => produtoModel != null && qtde.doubleValue > 0;

  late bool isEdit;

  PedidoProdutoCreateModel()
      : id = HashService.get,
        isEdit = false;

  PedidoProdutoCreateModel.edit(PedidoProdutoModel produto)
      : id = produto.id,
        isEdit = true;

  PedidoProdutoModel toPedidoProdutoModel(
          String pedidoId, ClienteModel cliente, ObraModel obra) =>
      PedidoProdutoModel(
        id: id,
        pedidoId: pedidoId,
        produto: produtoModel!,
        qtde: qtde.doubleValue,
        statusess: [
          PedidoProdutoStatusModel(
              id: HashService.get,
              status: PedidoProdutoStatus.separado,
              createdAt: DateTime.now())
        ],
        clienteId: cliente.id,
        obraId: obra.id,
      );
}
