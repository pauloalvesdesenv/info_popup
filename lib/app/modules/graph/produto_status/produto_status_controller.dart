// import 'dart:developer';

// import 'package:aco_plus/app/core/client/firestore/collections/produto/produto_model.dart';
// import 'package:aco_plus/app/core/client/firestore/firestore_client.dart';
// import 'package:aco_plus/app/core/extensions/double_ext.dart';
// import 'package:aco_plus/app/core/models/app_stream.dart';
// import 'package:aco_plus/app/core/utils/app_css.dart';
// import 'package:aco_plus/app/modules/graph/core/graph_model.dart';
// import 'package:aco_plus/app/modules/graph/produto_status/produto_status_model.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';

// final produtoStatusCtrl = ProdutoStatusController();

// class ProdutoStatusController {
//   static final ProdutoStatusController _instance = ProdutoStatusController._();

//   ProdutoStatusController._();

//   factory ProdutoStatusController() => _instance;

//   final AppStream<ProdutoStatusGraphModel> filterStream =
//       AppStream<ProdutoStatusGraphModel>.seed(ProdutoStatusGraphModel());
//   ProdutoStatusGraphModel get filter => filterStream.value;

//   // PEDIDOS QUE ENTRARAM QUE COMEÇARAM A PRODUÇÃO HOJE
//   // PEDIDOS QUE FORAM FINALIZADOS HOJE
//   SfCircularChart getCartesianChart(
//     ProdutoStatusGraphModel filter,
//   ) {
//     try {
//       List<ProdutoModel> produtos =
//           FirestoreClient.produtos.data.map((e) => e.copyWith()).toList();

//       List<GraphModel> source = [];

//       for (var status in PedidoProdutoStatus.values) {
//         double volFinal = 0.0;
//         double lengthFinal = 0.0;
//         for (ProdutoModel produto
//             in produtos.where((e) => e.status == status).toList()) {
//           volFinal += produto.produtos.length;
//           lengthFinal++;
//         }
//         if (volFinal > 0) {
//           source.add(GraphModel(
//               vol: volFinal,
//               label: status.label,
//               length: lengthFinal,
//               color: status.color));
//         }
//       }

//       return SfCircularChart(
//         tooltipBehavior: TooltipBehavior(
//           enable: true,
//           format: 'point.x : point.y Produto(s)',
//         ),
//         enableMultiSelection: true,
//         onDataLabelRender: (dataLabelArgs) {
//           dataLabelArgs.textStyle =
//               AppCss.smallBold.setColor(dataLabelArgs.color);
//         },
//         legend: const Legend(
//           isVisible: true,
//           overflowMode: LegendItemOverflowMode.wrap,
//           position: LegendPosition.bottom,
//         ),
//         series: <CircularSeries<GraphModel, String>>[
//           PieSeries<GraphModel, String>(
//             dataSource: source,
//             name: 'Produtos',
//             dataLabelMapper: (GraphModel data, _) => data.vol.toKg(),
//             pointColorMapper: (GraphModel data, _) => data.color,
//             xValueMapper: (GraphModel data, _) => data.label,
//             yValueMapper: (GraphModel data, _) => data.length,
//             dataLabelSettings: const DataLabelSettings(
//               isVisible: true,
//             ),
//           ),
//         ],
//       );
//     } catch (e) {
//       rethrow;
//     }
//   }
// }
