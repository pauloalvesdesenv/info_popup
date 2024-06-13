import 'package:aco_plus/app/modules/kanban/kanban_controller.dart';
import 'package:aco_plus/app/modules/kanban/kanban_view_model.dart';
import 'package:flutter/material.dart';

class KanbanBlackLensWidget extends StatelessWidget {
  final KanbanUtils utils;
  const KanbanBlackLensWidget(
    this.utils, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 400),
      opacity: utils.isPedidoSelected ? 1 : 0,
      child: !utils.isPedidoSelected
          ? const SizedBox()
          : InkWell(
              onTap: () {
                kanbanCtrl.setPedido(null);
              },
              child: Container(
                height: double.maxFinite,
                width: double.maxFinite,
                color: Colors.black.withOpacity(0.8),
              ),
            ),
    );
  }
}
