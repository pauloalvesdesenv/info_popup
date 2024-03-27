import 'package:aco_plus/app/core/client/firestore/collections/cliente/cliente_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_produto_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_produto_status_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/produto/produto_model.dart';
import 'package:aco_plus/app/core/services/hash_service.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';

class PedidoProdutoCreateModel {
  final String id;
  ProdutoModel? produtoModel;
  MoneyMaskedTextController qtde = MoneyMaskedTextController(rightSymbol: ' Kg');

  bool get isEnable => produtoModel != null && qtde.numberValue > 0;

  late bool isEdit;

  PedidoProdutoCreateModel()
      : id = HashService.get,
        isEdit = false;

  PedidoProdutoCreateModel.edit(PedidoProdutoModel produto)
      : id = produto.id,
        isEdit = true;

  PedidoProdutoModel toPedidoProdutoModel(ClienteModel cliente) => PedidoProdutoModel(
        id: id,
        produto: produtoModel!,
        qtde: qtde.numberValue,
        statusess: [
          PedidoProdutoStatusModel(
              id: HashService.get,
              status: PedidoProdutoStatus.aguardandoProducao,
              createdAt: DateTime.now())
        ],
        clienteId: cliente.id,
      );
}
