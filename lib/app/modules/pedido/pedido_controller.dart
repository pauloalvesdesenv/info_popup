import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_produto_status_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_status_model.dart';
import 'package:aco_plus/app/core/client/firestore/firestore_client.dart';
import 'package:aco_plus/app/core/enums/sort_type.dart';
import 'package:aco_plus/app/core/extensions/string_ext.dart';
import 'package:aco_plus/app/core/models/app_stream.dart';
import 'package:aco_plus/app/core/services/hash_service.dart';
import 'package:aco_plus/app/core/services/notification_service.dart';
import 'package:aco_plus/app/core/utils/global_resource.dart';
import 'package:aco_plus/app/modules/pedido/ui/pedido_status_bottom.dart';
import 'package:aco_plus/app/modules/pedido/view_models/pedido_view_model.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

final pedidoCtrl = PedidoController();
PedidoModel get pedido => pedidoCtrl.pedido;

class PedidoController {
  static final PedidoController _instance = PedidoController._();

  PedidoController._();

  factory PedidoController() => _instance;

  final AppStream<PedidoUtils> utilsStream =
      AppStream<PedidoUtils>.seed(PedidoUtils());
  PedidoUtils get utils => utilsStream.value;

  final AppStream<PedidoCreateModel> formStream =
      AppStream<PedidoCreateModel>();
  PedidoCreateModel get form => formStream.value;

  void onInitCreatePage(PedidoModel? pedido) {
    formStream.add(
        pedido != null ? PedidoCreateModel.edit(pedido) : PedidoCreateModel());
  }

  List<PedidoModel> getPedidoesFiltered(
      String search, List<PedidoModel> pedidos) {
    if (search.length < 3) return pedidos;
    List<PedidoModel> filtered = [];
    for (final pedido in pedidos) {
      if (pedido.toString().toCompare.contains(search.toCompare)) {
        filtered.add(pedido);
      }
    }
    return filtered;
  }

  Future<void> onConfirm(_, PedidoModel? pedido, bool isFromOrder) async {
    try {
      onValid();
      if (form.isEdit) {
        final edit = form.toPedidoModel(pedido);
        final update = await FirestoreClient.pedidos.update(edit);
        if (update != null) {
          pedidoStream.add(update);
          pedidoStream.update();
        }
      } else {
        await FirestoreClient.pedidos.add(form.toPedidoModel(pedido));
      }
      if (isFromOrder) {
        Navigator.pop(_, form.isEdit ? pedido : null);
      } else {
        pop(_);
      }
      NotificationService.showPositive(
          'Pedido ${form.isEdit ? 'Editado' : 'Adicionado'}',
          'Operação realizada com sucesso',
          position: NotificationPosition.bottom);
    } catch (e) {
      NotificationService.showNegative('Erro', e.toString(),
          position: NotificationPosition.bottom);
    }
  }

  Future<void> onDelete(_, PedidoModel pedido) async {
    if (await _isDeleteUnavailable(pedido)) return;
    await FirestoreClient.pedidos.delete(pedido);
    pop(_);
    NotificationService.showPositive(
        'Pedido Excluida', 'Operação realizada com sucesso',
        position: NotificationPosition.bottom);
  }

  Future<bool> _isDeleteUnavailable(PedidoModel pedido) async =>
      !await onDeleteProcess(
        deleteTitle: 'Deseja excluir o pedido?',
        deleteMessage: 'Todos seus dados do pedido apagados do sistema',
        infoMessage:
            'Não é possível exlcuir o pedido, pois ele está vinculado a uma ordem de produção.',
        conditional: FirestoreClient.ordens.data
            .expand((e) => e.produtos.map((e) => e.pedidoId))
            .any((e) => e == pedido.id),
      );

  void onValid() {
    if (form.cliente == null) {
      throw Exception('Localizador não pode ser vazio');
    }
    if (form.cliente == null) {
      throw Exception('Selecione o cliente do pedido');
    }
    if (form.tipo == null) {
      throw Exception('Selecione o tipo do pedido');
    }
    if (form.obra == null) {
      throw Exception('Selecione a obra do pedido');
    }
  }

  //PEDIDO
  final AppStream<PedidoModel> pedidoStream = AppStream<PedidoModel>();
  PedidoModel get pedido => pedidoStream.value;

  void onInitPage(PedidoModel pedido) {
    pedidoStream.add(pedido);
  }

  void onChangePedidoStatus(PedidoModel pedido) async {
    final status = await showPedidoStatusBottom(pedido);
    if (status == null) return;
    if (pedido.statusess.last.status == status) return;
    pedido.statusess.add(PedidoStatusModel(
      id: HashService.get,
      status: status,
      createdAt: DateTime.now(),
    ));
    pedidoStream.update();
    await FirestoreClient.pedidos.update(pedido);
  }

  Future<void> onVerifyPedidoStatus() async {
    final ordens = FirestoreClient.ordens.data;
    for (var pedido in FirestoreClient.pedidos.data) {
      for (var produtoPedido in pedido.produtos) {
        bool hasInOrder = false;
        for (var ordem in ordens) {
          for (var produtoOrdem in ordem.produtos) {
            if (pedido.id == produtoOrdem.pedidoId &&
                produtoPedido.id == produtoOrdem.id) {
              hasInOrder = true;
              break;
            }
          }
        }
        if (!hasInOrder &&
            produtoPedido.status.status ==
                PedidoProdutoStatus.aguardandoProducao) {
          produtoPedido.statusess.clear();
          produtoPedido.statusess.add(PedidoProdutoStatusModel(
              id: HashService.get,
              status: PedidoProdutoStatus.separado,
              createdAt: DateTime.now()));
        }
      }
      await FirestoreClient.pedidos.update(pedido);
    }
  }

  void onSortPedidos(List<PedidoModel> pedidos) {
    bool isAsc = utils.sortOrder == SortOrder.asc;
    switch (utils.sortType) {
      case SortType.alfabetic:
        pedidos.sort((a, b) => isAsc
            ? a.cliente.nome.compareTo(b.cliente.nome)
            : b.cliente.nome.compareTo(a.cliente.nome));
        break;
      case SortType.createdAt:
        pedidos.sort((a, b) => isAsc
            ? (a.deliveryAt ?? DateTime.now())
                .compareTo((b.deliveryAt ?? DateTime.now()))
            : (b.deliveryAt ?? DateTime.now())
                .compareTo((a.deliveryAt ?? DateTime.now())));
        break;
      default:
    }
  }

  void updatePedidoFirestore() {
    pedidoStream.update();
    FirestoreClient.pedidos.update(pedido);
  }
}
