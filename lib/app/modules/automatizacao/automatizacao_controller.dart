import 'dart:developer';

import 'package:aco_plus/app/core/client/firestore/collections/automatizacao/automatizacao_collection.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/enums/pedido_status.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/enums/pedido_tipo.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/step/models/step_model.dart';
import 'package:aco_plus/app/core/client/firestore/firestore_client.dart';
import 'package:aco_plus/app/modules/kanban/kanban_controller.dart';
import 'package:collection/collection.dart';

final automatizacaoCtrl = AutomatizacaoController();

class AutomatizacaoController {
  static final AutomatizacaoController _instance = AutomatizacaoController._();

  AutomatizacaoController._();

  factory AutomatizacaoController() => _instance;

  Future<void> onSetStepByPedidoStatus(List<PedidoModel> pedidos) async {
    try {
      for (PedidoModel pedido in pedidos) {
        StepModel? step;
        switch (pedido.status) {
          case PedidoStatus.aguardandoProducaoCD:
            step = automatizacaoConfig.produtoPedidoSeparado.step;
            break;
          case PedidoStatus.produzindoCD:
            step = automatizacaoConfig.produzindoCDPedido.step;
            break;
          case PedidoStatus.aguardandoProducaoCDA:
            step = automatizacaoConfig.aguardandoArmacaoPedido.step;
            break;
          case PedidoStatus.produzindoCDA:
            step = automatizacaoConfig.produzindoArmacaoPedido.step;
            break;
          case PedidoStatus.pronto:
            switch (pedido.tipo) {
              case PedidoTipo.cd:
                step = automatizacaoConfig.prontoCDPedido.step;
                break;
              case PedidoTipo.cda:
                step = automatizacaoConfig.prontoArmacaoPedido.step;
              default:
            }
            if (step != null) {
              if (pedido.step.index >= step.index) {
                step = null;
              }
            }

            break;
          default:
        }

        if (step != null) {
          if (!kanbanCtrl.utilsStream.controller.hasValue) {
            await kanbanCtrl.onInit();
          }
          kanbanCtrl.mountKanban();

          kanbanCtrl.onAccept(step, pedido, 0, auto: true);

        }
      }
    } catch (e) {
      log('erro att kanban');
      log(e.toString());
    }
  }
}
