import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/tag/models/tag_model.dart';
import 'package:flutter/material.dart';

class KanbanCardTagsWidget extends StatelessWidget {
  final PedidoModel pedido;
  const KanbanCardTagsWidget(
    this.pedido, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.start,
      runAlignment: WrapAlignment.start,
      alignment: WrapAlignment.start,
      runSpacing: 4,
      spacing: 4,
      children: pedido.tags.map((e) => _tagWidget(e)).toList(),
    );
  }

  Container _tagWidget(TagModel e) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration:
          BoxDecoration(color: e.color, borderRadius: BorderRadius.circular(4)),
      child: Text(
        e.nome,
        style: TextStyle(
          color: e.color.computeLuminance() > 0.5 ? Colors.black : Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
