import 'package:aco_plus/app/core/components/h.dart';
import 'package:aco_plus/app/core/components/stream_out.dart';
import 'package:aco_plus/app/modules/graph/pedido_etapa/pedido_etapa_controller.dart';
import 'package:aco_plus/app/modules/graph/pedido_etapa/pedido_etapa_model.dart';
import 'package:flutter/material.dart';

class PedidoEtapaWidget extends StatefulWidget {
  const PedidoEtapaWidget({super.key});

  @override
  State<PedidoEtapaWidget> createState() => _GrapOrdemhTotalWidgetState();
}

class _GrapOrdemhTotalWidgetState extends State<PedidoEtapaWidget> {
  @override
  void initState() {
    pedidoEtapaCtrl.filterStream.add(PedidoEtapaGraphModel());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamOut<PedidoEtapaGraphModel>(
      stream: pedidoEtapaCtrl.filterStream.listen,
      builder: (_, filter) => body(_, filter),
    );
  }

  Widget body(BuildContext context, PedidoEtapaGraphModel filter) {
    return Column(
      children: [
        const H(16),
        Expanded(child: pedidoEtapaCtrl.getCartesianChart(filter))
      ],
    );
  }
}
