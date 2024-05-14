import 'package:aco_plus/app/core/client/firestore/collections/ordem/models/ordem_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_produto_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/produto/produto_model.dart';
import 'package:aco_plus/app/core/client/firestore/firestore_client.dart';
import 'package:aco_plus/app/core/enums/sort_type.dart';
import 'package:aco_plus/app/core/models/text_controller.dart';

class OrdemUtils {
  final TextController search = TextController();
}

class OrdemCreateModel {
  String id;
  ProdutoModel? produto;
  TextController cliente = TextController();
  List<PedidoProdutoModel> produtos = [];
  SortType sortType = SortType.alfabetic;
  SortOrder sortOrder = SortOrder.asc;

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

  OrdemModel toOrdemModel(OrdemModel? ordem) {
    return OrdemModel(
      id: id,
      createdAt: DateTime.now(),
      produto: produto!,
      produtos: [
        ...produtos.where((e) => e.selected).toList(),
        if (ordem != null)
          ...ordem.produtos
              .where((e) => e.status.status.index >= 2 || e.selected)
              .toList()
      ],
    );
  }
}
