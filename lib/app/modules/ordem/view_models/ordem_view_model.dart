import 'package:aco_plus/app/core/client/firestore/collections/ordem/models/ordem_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_produto_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_produto_status_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/produto/produto_model.dart';
import 'package:aco_plus/app/core/client/firestore/firestore_client.dart';
import 'package:aco_plus/app/core/enums/sort_type.dart';
import 'package:aco_plus/app/core/models/text_controller.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class OrdemUtils {
  bool showFilter = false;
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
  TextController localizador = TextController();
  List<PedidoProdutoModel> produtos = [];
  SortType sortType = SortType.alfabetic;
  SortOrder sortOrder = SortOrder.asc;
  bool isCreate = false;
  DateTime? createdAt;
  OrdemFreezedCreateModel freezed = OrdemFreezedCreateModel();

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
    freezed = OrdemFreezedCreateModel.edit(pedido.freezed);
  }

  OrdemModel toOrdemModel() {
    return OrdemModel(
      id: id,
      createdAt: createdAt ?? DateTime.now(),
      produto: produto!,
      produtos: produtos
          .map(
            (e) => e.copyWith(
              statusess: [
                ...e.statusess,
                if (e.statusess.last.status !=
                    PedidoProdutoStatus.aguardandoProducao)
                  if (e.isSelected && e.isAvailableToChanges)
                    PedidoProdutoStatusModel.create(
                        PedidoProdutoStatus.aguardandoProducao)
              ],
            ),
          )
          .toList(),
      freezed: freezed.toOrdemFreeze(),
    );
  }
}

class OrdemFreezedCreateModel {
  TextController reason = TextController();
  bool isFreezed = false;
  DateTime updatedAt = DateTime.now();

  late bool isEdit;

  OrdemFreezedCreateModel() : isEdit = false;

  OrdemFreezedCreateModel.edit(OrdemFreezedModel freezed) : isEdit = true {
    isFreezed = freezed.isFreezed;
    reason = TextController(text: freezed.reason.text);
    updatedAt = freezed.updatedAt;
  }

  OrdemFreezedModel toOrdemFreeze() {
    return OrdemFreezedModel(
      isFreezed: isFreezed,
      reason: reason,
      updatedAt: updatedAt
    );
  }
}
