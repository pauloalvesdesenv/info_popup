import 'dart:developer';

import 'package:aco_plus/app/core/client/firestore/collections/ordem/models/ordem_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_produto_status_model.dart';
import 'package:aco_plus/app/core/client/firestore/firestore_client.dart';
import 'package:aco_plus/app/core/extensions/double_ext.dart';
import 'package:aco_plus/app/core/models/app_stream.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:aco_plus/app/modules/graph/core/graph_model.dart';
import 'package:aco_plus/app/modules/graph/ordem_total/graph_ordem_total_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

final graphOrdemTotalCtrl = GrahpOrdemTotalController();

class GrahpOrdemTotalController {
  static final GrahpOrdemTotalController _instance =
      GrahpOrdemTotalController._();

  GrahpOrdemTotalController._();

  factory GrahpOrdemTotalController() => _instance;

  final AppStream<GraphOrdemTotalModel> filterStream =
      AppStream<GraphOrdemTotalModel>.seed(GraphOrdemTotalModel());
  GraphOrdemTotalModel get filter => filterStream.value;

  SfCircularChart getCirucularChart(GraphOrdemTotalModel filter) {
    try {
      List<OrdemModel> ordens = FirestoreClient.ordens.data
          .map((o) => o.copyWith(
              produto: o.produto.copyWith(),
              produtos: o.produtos
                  .map((p) => p.copyWith(
                      statusess: p.statusess.map((s) => s.copyWith()).toList()))
                  .toList()))
          .toList();

      List<GraphModel> source = [];

      for (final status in PedidoProdutoStatus.values) {
        double volFinal = 0.0;
        double lengthFinal = 0.0;
        for (OrdemModel ordem in ordens) {
          final pedidos =
              ordem.produtos.where((p) => p.status.status == status).toList();
          double vol = pedidos.fold(.0, (a, b) => a + b.qtde);
          volFinal += vol;
          lengthFinal += pedidos.length;
        }
        if (volFinal > 0) {
          source.add(GraphModel(
              vol: volFinal,
              label: status.label,
              length: lengthFinal,
              color: status.color));
        }
      }

      return SfCircularChart(
        tooltipBehavior: TooltipBehavior(
          enable: true,
          format: 'point.x : point.y Pedido(s)',
        ),
        enableMultiSelection: true,
        onDataLabelRender: (dataLabelArgs) {
          dataLabelArgs.textStyle =
              AppCss.smallBold.setColor(dataLabelArgs.color);
        },
        legend: const Legend(
          isVisible: true,
          overflowMode: LegendItemOverflowMode.wrap,
          position: LegendPosition.bottom,
        ),
        series: <CircularSeries<GraphModel, String>>[
          PieSeries<GraphModel, String>(
            dataSource: source,
            name: 'Ordens',
            dataLabelMapper: (GraphModel data, _) => data.vol.toKg(),
            pointColorMapper: (GraphModel data, _) => data.color,
            xValueMapper: (GraphModel data, _) => data.label,
            yValueMapper: (GraphModel data, _) => data.length,
            dataLabelSettings: const DataLabelSettings(
              isVisible: true,
              labelPosition: ChartDataLabelPosition.outside,
            ),
          ),
        ],
      );
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
