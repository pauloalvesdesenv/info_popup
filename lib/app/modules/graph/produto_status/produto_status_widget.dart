// import 'package:aco_plus/app/core/components/h.dart';
// import 'package:aco_plus/app/core/components/stream_out.dart';
// import 'package:aco_plus/app/modules/graph/produto_status/produto_status_controller.dart';
// import 'package:aco_plus/app/modules/graph/produto_status/produto_status_model.dart';
// import 'package:flutter/material.dart';

// class ProdutoStatusWidget extends StatefulWidget {
//   const ProdutoStatusWidget({super.key});

//   @override
//   State<ProdutoStatusWidget> createState() => _GrapOrdemhTotalWidgetState();
// }

// class _GrapOrdemhTotalWidgetState extends State<ProdutoStatusWidget> {
//   @override
//   void initState() {
//     produtoStatusCtrl.filterStream.add(ProdutoStatusGraphModel());
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return StreamOut<ProdutoStatusGraphModel>(
//       stream: produtoStatusCtrl.filterStream.listen,
//       builder: (_, filter) => body(_, filter),
//     );
//   }

//   Widget body(BuildContext context, ProdutoStatusGraphModel filter) {
//     return Column(
//       children: [
//         const H(16),
//         Expanded(child: produtoStatusCtrl.getCartesianChart(filter))
//       ],
//     );
//   }
// }
