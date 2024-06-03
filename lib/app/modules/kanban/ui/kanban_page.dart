import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/step/models/step_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/tag/models/tag_model.dart';
import 'package:aco_plus/app/core/client/firestore/firestore_client.dart';
import 'package:aco_plus/app/core/components/app_drawer.dart';
import 'package:aco_plus/app/core/components/app_scaffold.dart';
import 'package:aco_plus/app/core/components/h.dart';
import 'package:aco_plus/app/core/components/stream_out.dart';
import 'package:aco_plus/app/core/components/w.dart';
import 'package:aco_plus/app/core/extensions/date_ext.dart';
import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:aco_plus/app/modules/base/base_controller.dart';
import 'package:flutter/material.dart';

class KanbanPage extends StatefulWidget {
  const KanbanPage({super.key});

  @override
  State<KanbanPage> createState() => _KanbanPageState();
}

class _KanbanPageState extends State<KanbanPage> {
  @override
  void initState() {
    FirestoreClient.steps.fetch();
    super.initState();
  }

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
        title: Text('Kaban', style: AppCss.largeBold.setColor(AppColors.white)),
        backgroundColor: AppColors.primaryMain,
      ),
      body: StreamOut(
        stream: FirestoreClient.steps.dataStream.listen,
        builder: (context, steps) => StreamOut(
          stream: FirestoreClient.pedidos.dataStream.listen,
          builder: (context, pedidos) => Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
              image: AssetImage('assets/images/kanban_background.png'),
              fit: BoxFit.cover,
            )),
            child: Column(
              children: [
                const H(16),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: steps.length,
                    scrollDirection: Axis.horizontal,
                    separatorBuilder: (_, i) => const W(16),
                    itemBuilder: (_, i) => _stepWidget(
                        steps[i],
                        pedidos
                            .where((e) => steps[i].id == e.step.id)
                            .toList()),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _stepWidget(StepModel step, List<PedidoModel> pedidos) {
    return Container(
      width: 300,
      // padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Color(0xFFF1F2F4),
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              step.name,
              style: AppCss.minimumBold,
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              separatorBuilder: (_, __) => const H(8),
              itemCount: pedidos.length,
              itemBuilder: (_, e) => _pedidoWidget(context, pedidos[e]),
            ),
          )
        ],
      ),
    );
  }

  Widget _pedidoWidget(BuildContext context, PedidoModel pedido) {
    return Container(
      width: double.maxFinite,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: const Color(0xFFFFFFFF),
          borderRadius: const BorderRadius.all(Radius.circular(6)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF000000).withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 1,
              offset: const Offset(0, 0),
            ),
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _tagsWidget(pedido),
          const H(8),
          Text(pedido.localizador),
          const H(8),
          _detailsWidget(pedido)
        ],
      ),
    );
  }

  Wrap _tagsWidget(PedidoModel pedido) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.start,
      runAlignment: WrapAlignment.start,
      alignment: WrapAlignment.start,
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

  Widget _detailsWidget(PedidoModel pedido) {
    return Wrap(
      children: [
        if (pedido.deliveryAt != null)
          _detailWidget(
            Icons.timer_outlined,
            value: pedido.deliveryAt!.toddMM(),
          ),
      ],
    );
  }

  Widget _detailWidget(IconData icon, {String? value}) {
    return Row(
      children: [
        Icon(
          icon,
          color: const Color(0xFF787C86),
          size: 14,
        ),
        if (value != null) ...[
          const W(4),
          Text(
            value,
            style: const TextStyle(color: Color(0xFF787C86), fontSize: 12),
          ),
        ]
      ],
    );
  }
}
