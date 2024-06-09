import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/step/models/step_model.dart';
import 'package:aco_plus/app/modules/kanban/ui/components/step/kanban_step_body_widget.dart';
import 'package:aco_plus/app/modules/kanban/ui/components/step/kanban_step_titile_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class KanbanStepWidget extends StatelessWidget {
  final StepModel step;
  final List<PedidoModel> pedidos;
  const KanbanStepWidget(
    this.step,
    this.pedidos, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      decoration: const BoxDecoration(
        color: Color(0xFFF1F2F4),
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          KanbanStepTitleWidget(step, pedidos),
          Expanded(
            child: KanbanStepBodyWidget(step, pedidos),
          )
        ],
      ),
    );
  }
}
