import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/step/models/step_model.dart';
import 'package:aco_plus/app/modules/kanban/kanban_controller.dart';
import 'package:aco_plus/app/modules/kanban/ui/components/card/kanban_card_draggable_widget.dart';
import 'package:flutter/material.dart';
import 'package:separated_column/separated_column.dart';

class KanbanStepBodyWidget extends StatelessWidget {
  final StepModel step;
  final List<PedidoModel> pedidos;
  const KanbanStepBodyWidget(
    this.step,
    this.pedidos, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: step.isEnable ? Colors.grey[50] : Colors.red.withOpacity(0.05),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(8),
          bottomRight: Radius.circular(8),
        ),
      ),
      child: Scrollbar(
        controller: step.scrollController,
        interactive: true,
        radius: const Radius.circular(4),
        thickness: 8,
        child: ListView(
          controller: step.scrollController,
          children: [
            _dragTargetWidget(step, pedidos, 0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: SeparatedColumn(
                separatorBuilder: (_, i) =>
                    _dragTargetWidget(step, pedidos, i + 1),
                children:
                    pedidos.map((e) => KanbanCardDraggableWidget(e)).toList(),
              ),
            ),
            _dragTargetWidget(step, pedidos, pedidos.length, isLast: true),
          ],
        ),
      ),
    );
  }

  Widget _dragTargetWidget(StepModel step, List<PedidoModel> pedidos, int index,
          {bool isLast = false}) =>
      DragTarget<PedidoModel>(
        onAcceptWithDetails: (details) =>
            kanbanCtrl.onAccept(step, details.data, index),
        builder: (context, candidateData, rejectedData) {
          bool isHover = candidateData.isNotEmpty;
          bool isEnable = step.isEnable;
          return AnimatedOpacity(
            opacity: isEnable && isHover ? 1 : 0,
            duration: const Duration(milliseconds: 100),
            child: Container(
              width: double.maxFinite,
              margin: isHover
                  ? EdgeInsets.symmetric(
                      vertical: 8, horizontal: isLast ? 8 : 0)
                  : null,
              height: isHover || isLast ? 70 : 8,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );
        },
      );
}
