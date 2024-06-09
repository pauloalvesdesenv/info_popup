import 'package:aco_plus/app/modules/kanban/kanban_view_model.dart';
import 'package:aco_plus/app/modules/kanban/ui/components/kanban/kanban_black_lens_widget.dart';
import 'package:aco_plus/app/modules/kanban/ui/components/kanban/kanban_pedido_selected_widget.dart';
import 'package:aco_plus/app/modules/kanban/ui/components/step/kanban_steps_widget.dart';
import 'package:flutter/material.dart';

class KanbanBodyWidget extends StatelessWidget {
  final KanbanUtils utils;
  const KanbanBodyWidget(
    this.utils, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
        image: AssetImage('assets/images/kanban_background.png'),
        fit: BoxFit.cover,
      )),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            children: [
              Expanded(
                child: KanbanStepsWidget(utils),
              )
            ],
          ),
          KanbanBlackLensWidget(utils),
          KanbanPedidoSelectedWidget(utils),
        ],
      ),
    );
  }
}
