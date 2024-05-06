import 'package:aco_plus/app/core/client/firestore/collections/ordem/models/ordem_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_produto_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/produto/produto_model.dart';
import 'package:aco_plus/app/core/client/firestore/firestore_client.dart';
import 'package:aco_plus/app/core/models/text_controller.dart';

class OrdemUtils {
  final TextController search = TextController();
}

class OrdemCreateModel {
  String id;
  ProdutoModel? produto;
  List<PedidoProdutoModel> produtos = [];

  late bool isEdit;

  OrdemCreateModel()
      : id = (FirestoreClient.ordens.data.length + 1).toString(),
        isEdit = false;

  OrdemCreateModel.edit(OrdemModel pedido)
      : id = pedido.id,
        isEdit = true {
    produto = FirestoreClient.produtos.data
        .firstWhere((e) => e.id == pedido.produto.id);
  }


  List<String> getIdPedidosSelecteds({OrdemModel? ordem}) {
    List<PedidoProdutoModel> products =
        produtos.where((e) => e.selected).map((e) => e.copyWith()).toList();
    if (ordem != null) {
      products = ordem.produtos.where((e) => e.selected).toList()
        ..addAll(products);
    }
    List<String> pedidos = [];
    for (var produto in products) {
      pedidos.add(produto.pedidoId);
    }
    return pedidos;
  }

  OrdemModel toOrdemModel(OrdemModel? ordem) {
    final products =
        produtos.where((e) => e.selected).map((e) => e.copyWith()).toList();
    return OrdemModel(
      id: id,
      createdAt: DateTime.now(),
      produto: produto!,
      produtos: ordem != null
          ? (ordem.produtos.where((e) => e.selected).toList()..addAll(products))
          : produtos,
    );
  }
}
