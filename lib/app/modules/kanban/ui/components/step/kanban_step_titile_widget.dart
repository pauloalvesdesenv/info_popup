import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/step/models/step_model.dart';
import 'package:aco_plus/app/core/extensions/double_ext.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:aco_plus/app/modules/kanban/kanban_controller.dart';
import 'package:flutter/material.dart';

class KanbanStepTitleWidget extends StatelessWidget {
  final StepModel step;
  final List<PedidoModel> pedidos;
  const KanbanStepTitleWidget(
    this.step,
    this.pedidos, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      dense: false,
      minTileHeight: 30,
      tilePadding: const EdgeInsets.only(left: 8),
      childrenPadding: const EdgeInsets.symmetric(horizontal: 8),
      trailing: PopupMenuButton(
        style: ButtonStyle(
          padding: WidgetStateProperty.all(EdgeInsets.zero),
          fixedSize: WidgetStateProperty.all(const Size(10, 10)),
        ),
        padding: EdgeInsets.zero,
        surfaceTintColor: Colors.white,
        color: Colors.white,
        itemBuilder: (context) => [
          PopupMenuItem(
              child: Row(
            children: [
              Expanded(
                  child:
                      Text('Ordenação', style: AppCss.minimumBold.setSize(16))),
              const Icon(
                Icons.close,
                color: Colors.black,
                size: 16,
              )
            ],
          )),
          PopupMenuItem(
            onTap: () {
              pedidos.sort((b, a) => a.createdAt.compareTo(b.createdAt));
              for (var i = 0; i < pedidos.length; i++) {
                pedidos[i].index = i;
              }
              kanbanCtrl.utilsStream.update();
            },
            child: const Text('Data de criação (mais recente primeiro)'),
          ),
          PopupMenuItem(
            onTap: () {
              pedidos.sort((a, b) => a.createdAt.compareTo(b.createdAt));
              for (var i = 0; i < pedidos.length; i++) {
                pedidos[i].index = i;
              }
              kanbanCtrl.utilsStream.update();
            },
            child: const Text('Data de criação (mais antigo primeiro)'),
          ),
          PopupMenuItem(
            onTap: () {
              pedidos.sort((a, b) => a.localizador.compareTo(b.localizador));
              for (var i = 0; i < pedidos.length; i++) {
                pedidos[i].index = i;
              }
              kanbanCtrl.utilsStream.update();
            },
            child: const Text('Nome do cartão (em ordem alfabética)'),
          ),
          PopupMenuItem(
            onTap: () {
              pedidos.sort((a, b) => [a.deliveryAt, b.deliveryAt].contains(null)
                  ? a.deliveryAt!.compareTo(b.deliveryAt!)
                  : 0);
              for (var i = 0; i < pedidos.length; i++) {
                pedidos[i].index = i;
              }
              kanbanCtrl.utilsStream.update();
            },
            child: const Text('Data de entrega'),
          ),
        ],
      ),
      title: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    step.name,
                    style: AppCss.minimumBold,
                  ),
                ),
                if (!step.isEnable)
                  Container(
                      margin: const EdgeInsets.only(left: 4),
                      child:
                          const Icon(Icons.lock, color: Colors.red, size: 12)),
              ],
            ),
          ),
          Text(
            pedidos
                .map((e) => e.getQtdeTotal())
                .fold(.0, (a, b) => a + b)
                .toKg(),
            style: AppCss.minimumRegular,
          ),
        ],
      ),
      onExpansionChanged: (e) {},
      children: const <Widget>[],
    );
  }
}
