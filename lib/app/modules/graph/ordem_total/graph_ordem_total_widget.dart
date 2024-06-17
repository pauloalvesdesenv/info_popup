import 'package:aco_plus/app/core/components/h.dart';
import 'package:aco_plus/app/core/components/stream_out.dart';
import 'package:aco_plus/app/modules/graph/ordem_total/graph_ordem_total_controller.dart';
import 'package:aco_plus/app/modules/graph/ordem_total/graph_ordem_total_model.dart';
import 'package:flutter/material.dart';

class GraphOrdemTotalWidget extends StatefulWidget {
  const GraphOrdemTotalWidget({super.key});

  @override
  State<GraphOrdemTotalWidget> createState() => _GrapOrdemhTotalWidgetState();
}

class _GrapOrdemhTotalWidgetState extends State<GraphOrdemTotalWidget> {
  @override
  void initState() {
    graphOrdemTotalCtrl.filterStream.add(GraphOrdemTotalModel());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamOut<GraphOrdemTotalModel>(
      stream: graphOrdemTotalCtrl.filterStream.listen,
      builder: (_, filter) => body(_, filter),
    );
  }

  Widget body(BuildContext context, GraphOrdemTotalModel filter) {
    return Column(
      children: [
        const H(16),
        Expanded(child: graphOrdemTotalCtrl.getCirucularChart(filter))
      ],
    );
  }
}
