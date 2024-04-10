import 'package:aco_plus/app/core/client/firestore/collections/cliente/cliente_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/enums/pedido_status.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/enums/pedido_tipo.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_status_model.dart';
import 'package:aco_plus/app/core/client/firestore/firestore_client.dart';
import 'package:aco_plus/app/core/models/text_controller.dart';
import 'package:aco_plus/app/core/services/hash_service.dart';
import 'package:aco_plus/app/modules/pedido/view_models/pedido_produto_view_model.dart';
import 'package:collection/collection.dart';

class PedidoUtils {
  final TextController search = TextController();
}

class PedidoCreateModel {
  final String id;
  final TextController localizador = TextController();
  final TextController nome = TextController();
  final TextController descricao = TextController();
  ClienteModel? cliente;
  ClienteModel? clienteAdd;
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
        isEdit = true {
    localizador.text = pedido.localizador;
    descricao.text = pedido.descricao;
    cliente = FirestoreClient.clientes.getById(pedido.cliente.id);
    obra = cliente?.obras.firstWhereOrNull((e) => e.id == pedido.obra.id);
    tipo = pedido.tipo;
    produtos = pedido.produtos.map((e) => PedidoProdutoCreateModel.edit(e)).toList();
  }

  PedidoModel toPedidoModel(PedidoModel? pedido) => PedidoModel(
        id: id,
        tipo: tipo!,
        descricao: descricao.text,
        statusess: [
          PedidoStatusModel(
              id: HashService.get,
              status: PedidoStatus.produzindoCD,
              createdAt: pedido?.statusess.first.createdAt ?? DateTime.now())
        ],
        localizador: localizador.text,
        createdAt: pedido?.createdAt ?? DateTime.now(),
        cliente: cliente!,
        obra: obra!,
        produtos:
            produtos.map((e) => e.toPedidoProdutoModel(id, cliente!, obra!).copyWith()).toList(),
      );
}
