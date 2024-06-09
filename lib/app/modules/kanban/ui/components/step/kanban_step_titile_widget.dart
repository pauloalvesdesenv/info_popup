import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/step/models/step_model.dart';
import 'package:aco_plus/app/core/extensions/double_ext.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
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
      tilePadding: const EdgeInsets.symmetric(horizontal: 8),
      childrenPadding: const EdgeInsets.symmetric(horizontal: 8),
      title: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Text(
                  step.name,
                  style: AppCss.minimumBold,
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
