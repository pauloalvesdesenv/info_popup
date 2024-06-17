import 'package:aco_plus/app/core/components/h.dart';
import 'package:aco_plus/app/core/components/stream_out.dart';
import 'package:aco_plus/app/modules/graph/pedido_status/pedido_status_controller.dart';
import 'package:aco_plus/app/modules/graph/pedido_status/pedido_status_model.dart';
import 'package:flutter/material.dart';

class PedidoStatusWidget extends StatefulWidget {
  const PedidoStatusWidget({super.key});

  @override
  State<PedidoStatusWidget> createState() => _GrapOrdemhTotalWidgetState();
}

class _GrapOrdemhTotalWidgetState extends State<PedidoStatusWidget> {
  @override
  void initState() {
    pedidoStatusCtrl.filterStream.add(PedidoStatusGraphModel());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamOut<PedidoStatusGraphModel>(
      stream: pedidoStatusCtrl.filterStream.listen,
      builder: (_, filter) => body(_, filter),
    );
  }

  Widget body(BuildContext context, PedidoStatusGraphModel filter) {
    return Column(
      children: [
        const H(16),
        Expanded(child: pedidoStatusCtrl.getCartesianChart(filter))
      ],
    );
  }
}
