import 'dart:math';

import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_model.dart';
import 'package:aco_plus/app/core/components/h.dart';
import 'package:aco_plus/app/core/components/w.dart';
import 'package:aco_plus/app/core/extensions/date_ext.dart';
import 'package:aco_plus/app/modules/kanban/kanban_controller.dart';
import 'package:aco_plus/app/modules/kanban/ui/components/card/kanban_card_details_widget.dart';
import 'package:aco_plus/app/modules/kanban/ui/components/card/kanban_card_pedido_widget.dart';
import 'package:aco_plus/app/modules/kanban/ui/components/card/kanban_card_tags_widget.dart';
import 'package:aco_plus/app/modules/kanban/ui/components/card/kanban_card_users_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class KanbanCardDraggableWidget extends StatelessWidget {
  final PedidoModel pedido;
  const KanbanCardDraggableWidget(
    this.pedido, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LongPressDraggable<PedidoModel>(
        delay: const Duration(milliseconds: 180),
        data: pedido,
        childWhenDragging: SizedBox(
          width: 290,
          child: Opacity(opacity: 0.2, child: KanbanCardPedidoWidget(pedido)),
        ),
        feedback: _feedbackPedidoWidget(pedido),
        child: KanbanCardPedidoWidget(pedido));
  }

  Widget _feedbackPedidoWidget(PedidoModel pedido) {
    return Transform.rotate(
      angle: -pi / 200 * -5,
      child: Opacity(
        opacity: 0.8,
        child: Material(
            child: IntrinsicHeight(
          child: SizedBox(width: 290, child: KanbanCardPedidoWidget(pedido)),
        )),
      ),
    );
  }
}
