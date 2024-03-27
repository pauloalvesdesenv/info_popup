import 'package:aco_plus/app/core/client/firestore/collections/cliente/cliente_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/enums/pedido_status.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/enums/pedido_tipo.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_status_model.dart';
import 'package:aco_plus/app/core/client/firestore/firestore_client.dart';
import 'package:aco_plus/app/modules/pedido/view_models/pedido_produto_view_model.dart';
import 'package:flutter/material.dart';

class PedidoUtils {
  final TextEditingController search = TextEditingController();
}

class PedidoCreateModel {
  final String id;
  final TextEditingController localizador = TextEditingController();
  final TextEditingController nome = TextEditingController();
  ClienteModel? cliente;
  ObraModel? obra;
  PedidoTipo? tipo;
  PedidoProdutoCreateModel produto = PedidoProdutoCreateModel();
  List<PedidoProdutoCreateModel> produtos = [];

  late bool isEdit;

  PedidoCreateModel()
      : id = (FirestoreClient.pedidos.data.length + 1).toString(),
        isEdit = false;

  PedidoCreateModel.edit(PedidoModel pedido)
      : id = pedido.id,
        isEdit = true;

  PedidoModel toPedidoModel() => PedidoModel(
        id: id,
        tipo: tipo!,
        statusess: [
          PedidoStatusModel(
              status: PedidoStatus.produzindoCD, createdAt: DateTime.now())
        ],
        localizador: localizador.text,
        createdAt: DateTime.now(),
        cliente: cliente!,
        obra: obra!,
        produtos: produtos
            .map((e) => e.toPedidoProdutoModel(id, cliente!, obra!).copyWith())
            .toList(),
      );
}
