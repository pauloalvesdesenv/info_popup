import 'package:aco_plus/app/core/client/firestore/firestore_client.dart';
import 'package:aco_plus/app/core/components/app_drawer.dart';
import 'package:aco_plus/app/core/components/app_scaffold.dart';
import 'package:aco_plus/app/core/components/divisor.dart';
import 'package:aco_plus/app/core/components/h.dart';
import 'package:aco_plus/app/core/components/stream_out.dart';
import 'package:aco_plus/app/core/components/type_selector_widget.dart';
import 'package:aco_plus/app/core/components/w.dart';
import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:aco_plus/app/modules/base/base_controller.dart';
import 'package:aco_plus/app/modules/dashboard/dashboard_controller.dart';
import 'package:aco_plus/app/modules/dashboard/dashboard_view_model.dart';
import 'package:aco_plus/app/modules/graph/ordem_total/graph_ordem_total_widget.dart';
import 'package:aco_plus/app/modules/graph/pedido_etapa/pedido_etapa_widget.dart';
import 'package:aco_plus/app/modules/graph/pedido_status/pedido_status_widget.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => DashboardPageState();
}

class DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
        drawer: const AppDrawer(),
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => baseCtrl.key.currentState!.openDrawer(),
            icon: Icon(
              Icons.menu,
              color: AppColors.white,
            ),
          ),
          title: Text('Dashboard',
              style: AppCss.largeBold.setColor(AppColors.white)),
          backgroundColor: AppColors.primaryMain,
        ),
        body: body());
  }

  Widget body() {
    return StreamOut(
      stream: FirestoreClient.pedidos.dataStream.listen,
      builder: (_, pedidos) => StreamOut(
        stream: FirestoreClient.ordens.dataStream.listen,
        builder: (_, __) => StreamOut(
          stream: dashCtrl.utilsStream.listen,
          builder: (_, utils) => ListView(
            // padding: EdgeInsets.zero,
            children: [
              // const Divisor(),
              Row(
                children: [
                  Expanded(child: _graficoOrdemStatus()),
                  Expanded(child: _graficoPedidoStatus()),
                  Expanded(child: _graficoPedidoEtapa()),
                ],
              ),
              const Divisor(),
              // const Divisor(),
              // _graficoCompradores(),
              // const Divisor(),
              // _graficoTotalOrdens(),
              // const Divisor(),
              // _rankingTranportadoras(utils),
              // _rank(utils),
              // _totaisWidget(),
              // _musicoFaseWidget(),
              // _organistaFaseWidget(),
            ],
          ),
        ),
      ),
    );
  }

  // Padding _cardPedidosHoje(List<PedidoModel> pedidos) {
  //   final pedidosHoje =
  //       pedidos.where((e) => e.step.id == 'w86haIA8OHtMubyFS2TOhOZ1I').toList();
  //   return Padding(
  //     padding: const EdgeInsets.all(16),
  //     child: Column(
  //       children: [
  //         Text('Pedidos (Hoje)', style: AppCss.mediumBold),
  //         const H(16),
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             Column(
  //               children: [
  //                 Text('Pedidos',
  //                     style: AppCss.mediumBold
  //                         .copyWith(color: AppColors.primaryMain)),
  //                 Text(pedidosHoje.length.toString(),
  //                     style: AppCss.largeBold
  //                         .copyWith(color: AppColors.primaryMain)),
  //               ],
  //             ),
  //             const W(24),
  //             Column(
  //               children: [
  //                 Text('Concluidos',
  //                     style:
  //                         AppCss.mediumBold.copyWith(color: AppColors.success)),
  //                 Text(
  //                     FirestoreClient.pedidos.data
  //                         .where((e) => e.status == PedidoStatus.pronto)
  //                         .length
  //                         .toString(),
  //                     style:
  //                         AppCss.largeBold.copyWith(color: AppColors.success)),
  //               ],
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _graficoPedidoEtapa() {
    return Container(
      padding: const EdgeInsets.all(16),
      height: 400,
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(color: Colors.grey[200]!, width: 0.8),
          left: BorderSide(color: Colors.grey[200]!, width: 0.8),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.pie_chart,
                size: 32,
              ),
              const W(8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'PEDIDOS POR ETAPA',
                      style: AppCss.largeBold.setSize(22).setHeight(1.2),
                    ),
                    Text(
                      'Total em kilos dos pedidos separados por etapas',
                      style: AppCss.mediumRegular.setSize(13).setHeight(1.2),
                    ),
                  ],
                ),
              ),
              const W(24)
            ],
          ),
          const H(8),
          const Expanded(child: PedidoEtapaWidget())
        ],
      ),
    );
  }

  Widget _graficoPedidoStatus() {
    return Container(
      padding: const EdgeInsets.all(16),
      height: 400,
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(color: Colors.grey[200]!, width: 0.8),
          left: BorderSide(color: Colors.grey[200]!, width: 0.8),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.pie_chart,
                size: 32,
              ),
              const W(8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'PEDIDOS POR STATUS',
                      style: AppCss.largeBold.setSize(22).setHeight(1.2),
                    ),
                    Text(
                      'Total em kilos dos pedidos separados por status',
                      style: AppCss.mediumRegular.setSize(13).setHeight(1.2),
                    ),
                  ],
                ),
              ),
              const W(24)
            ],
          ),
          const H(8),
          const Expanded(child: PedidoStatusWidget())
        ],
      ),
    );
  }

  Widget _graficoOrdemStatus() {
    return Container(
      padding: const EdgeInsets.all(16),
      height: 400,
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(color: Colors.grey[200]!, width: 0.8),
          left: BorderSide(color: Colors.grey[200]!, width: 0.8),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.pie_chart,
                size: 32,
              ),
              const W(8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ORDENS POR STATUS',
                      style: AppCss.largeBold.setSize(22).setHeight(1.2),
                    ),
                    Text(
                      'Total em kilos das ordens de produção separados por status',
                      style: AppCss.mediumRegular.setSize(13).setHeight(1.2),
                    ),
                  ],
                ),
              ),
              const W(24)
            ],
          ),
          const H(8),
          const Expanded(child: GraphOrdemTotalWidget())
        ],
      ),
    );
  }

  Widget _graficoTotalOrdens() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        height: 440,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.pie_chart_outline),
                const W(8),
                Expanded(
                  child: Text(
                    'Total de ordens',
                    style: AppCss.largeBold.setSize(21),
                  ),
                ),
                const W(24)
              ],
            ),
            const H(8),
            // const Expanded(child: GraphOrdemTotalWidget())
            Expanded(child: Container())
          ],
        ),
      ),
    );
  }

  Widget _rankingTranportadoras(DashboardUtils utils) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.sort_outlined),
              const W(2),
              const Icon(Icons.local_shipping_outlined),
              const W(8),
              Expanded(
                child: Text(
                  'Ranking de Transportadoras',
                  style: AppCss.largeBold.setSize(21),
                ),
              ),
            ],
          ),
          const H(8),
          TypeSelectorWidget<DashboardClienteRankingType>(
            label: '',
            values: DashboardClienteRankingType.values,
            value: utils.clienteRankingType,
            onChanged: (e) {
              utils.clienteRankingType = e;
              dashCtrl.utilsStream.update();
            },
            itemLabel: (e) => e.label,
            itemColorDisable: (e) => Colors.grey.withOpacity(0.1),
          ),
          const H(8),
          Builder(builder: (context) {
            final ranking = dashCtrl.getRankingClientes();
            return Column(
              children: ranking
                  .map((e) => Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${ranking.indexOf(e) + 1}º  ',
                                style: AppCss.mediumBold
                                    .setColor(Colors.grey[800]!),
                              ),
                              Text(
                                e.model.nome,
                                style: AppCss.mediumBold
                                    .copyWith(fontWeight: FontWeight.w400)
                                    .setColor(Colors.grey[800]!),
                              ),
                              const Spacer(),
                              Text(
                                e.value,
                                style: AppCss.mediumBold
                                    .copyWith(fontWeight: FontWeight.w400)
                                    .setColor(Colors.grey[800]!),
                              ),
                            ],
                          ),
                          const H(8),
                          Divisor(
                            color: Colors.grey[200],
                          ),
                        ],
                      ))
                  .toList(),
            );
          })
        ],
      ),
    );
  }
}
