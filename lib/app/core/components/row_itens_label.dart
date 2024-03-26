import 'package:flutter/material.dart';
import 'package:programacao/app/core/components/item_label.dart';

class RowItensLabel extends StatelessWidget {
  final List<ItemLabel> itens;
  const RowItensLabel(this.itens, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: itens
          .map((e) => Expanded(
                child: e,
              ))
          .toList(),
    );
  }
}
