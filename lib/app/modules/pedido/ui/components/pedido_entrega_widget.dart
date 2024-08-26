import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_model.dart';
import 'package:aco_plus/app/core/components/h.dart';
import 'package:aco_plus/app/core/components/item_label.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:flutter/material.dart';

class PedidoEntregaWidget extends StatelessWidget {
  final PedidoModel pedido;
  const PedidoEntregaWidget(
    this.pedido, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Entrega', style: AppCss.largeBold),
          if (pedido.instrucoesEntrega.isNotEmpty) ...[
            const H(16),
            ItemLabel('Instruções de Entrega', pedido.instrucoesEntrega),
          ],
        ],
      ),
    );
  }
}
