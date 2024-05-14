import 'package:aco_plus/app/core/client/firestore/collections/pedido/enums/pedido_status.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/enums/pedido_tipo.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_produto_status_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_status_model.dart';
import 'package:aco_plus/app/core/components/app_scaffold.dart';
import 'package:aco_plus/app/core/components/divisor.dart';
import 'package:aco_plus/app/core/components/h.dart';
import 'package:aco_plus/app/core/components/item_label.dart';
import 'package:aco_plus/app/core/components/row_itens_label.dart';
import 'package:aco_plus/app/core/components/stream_out.dart';
import 'package:aco_plus/app/core/components/w.dart';
import 'package:aco_plus/app/core/extensions/date_ext.dart';
import 'package:aco_plus/app/core/extensions/double_ext.dart';
import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:aco_plus/app/core/utils/global_resource.dart';
import 'package:aco_plus/app/modules/pedido/pedido_controller.dart';
import 'package:aco_plus/app/modules/pedido/ui/pedido_create_page.dart';
import 'package:flutter/material.dart';

class PedidoPage extends StatefulWidget {
  final PedidoModel pedido;
  const PedidoPage(this.pedido, {super.key});

  @override
  State<PedidoPage> createState() => _PedidoPageState();
}

class _PedidoPageState extends State<PedidoPage> {
  @override
  void initState() {
    pedidoCtrl.onInitPage(widget.pedido);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
        resizeAvoid: true,
        appBar: AppBar(
          title: Text(widget.pedido.localizador,
              style: AppCss.largeBold.setColor(AppColors.white)),
          backgroundColor: AppColors.primaryMain,
          actions: [
            IconButton(
                onPressed: () async =>
                    push(context, PedidoCreatePage(pedido: widget.pedido)),
                icon: Icon(Icons.edit, color: AppColors.white)),
            IconButton(
                onPressed: () async =>
                    pedidoCtrl.onDelete(context, widget.pedido),
                icon: Icon(Icons.delete, color: AppColors.white))
          ],
        ),
        body: StreamOut(
            stream: pedidoCtrl.pedidoStream.listen,
            builder: (_, form) => body(form)));
  }

  Widget body(PedidoModel form) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RowItensLabel([
                ItemLabel('Cliente', form.cliente.nome),
                ItemLabel('Obra', form.obra.descricao),
              ]),
              const H(16),
              RowItensLabel([
                ItemLabel('Descrição',
                    form.descricao.isEmpty ? 'Sem descrição' : form.descricao),
                ItemLabel('Data Entrega', form.deliveryAt.text()),
              ]),
            ],
          ),
        ),
        const Divisor(),
        Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                  child: Text('Status do Pedido', style: AppCss.largeBold)),
              InkWell(
                onTap: pedido.isChangeStatusAvailable
                    ? () => pedidoCtrl.onChangePedidoStatus(pedido)
                    : null,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                      color:
                          pedido.statusess.last.status.color.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(4)),
                  child: IntrinsicWidth(
                    child: Row(
                      children: [
                        Text(pedido.statusess.last.status.label,
                            style: AppCss.mediumRegular.setSize(12)),
                        if (pedido.isChangeStatusAvailable) ...{
                          const W(2),
                          Icon(Icons.keyboard_arrow_down,
                              size: 16, color: AppColors.black.withOpacity(0.6))
                        }
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        const Divisor(),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Corte e Dobra', style: AppCss.largeBold),
              const H(8),
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: Text('Aguardando Produção',
                              style: AppCss.mediumRegular)),
                      Text(
                        '${form.getQtdeAguardandoProducao().formatted}Kg (${(form.getPrcntgAguardandoProducao() * 100).percent}%)',
                      )
                    ],
                  ),
                  const H(8),
                  LinearProgressIndicator(
                    value: form.getPrcntgAguardandoProducao(),
                    backgroundColor: PedidoProdutoStatus
                        .aguardandoProducao.color
                        .withOpacity(0.3),
                    valueColor: AlwaysStoppedAnimation(
                        PedidoProdutoStatus.aguardandoProducao.color),
                  ),
                ],
              ),
              const H(16),
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                          child:
                              Text('Produzindo', style: AppCss.mediumRegular)),
                      Text(
                        '${form.getQtdeProduzindo().formatted}Kg (${(form.getPrcntgProduzindo() * 100).percent}%)',
                      )
                    ],
                  ),
                  const H(8),
                  LinearProgressIndicator(
                    value: form.getPrcntgProduzindo(),
                    backgroundColor:
                        PedidoProdutoStatus.produzindo.color.withOpacity(0.3),
                    valueColor: AlwaysStoppedAnimation(
                        PedidoProdutoStatus.produzindo.color),
                  ),
                ],
              ),
              const H(16),
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: Text('Pronto', style: AppCss.mediumRegular)),
                      Text(
                        '${form.getQtdePronto().formatted}Kg (${(form.getPrcntgPronto() * 100).percent}%)',
                      )
                    ],
                  ),
                  const H(8),
                  LinearProgressIndicator(
                    value: form.getPrcntgPronto(),
                    backgroundColor:
                        PedidoProdutoStatus.pronto.color.withOpacity(0.3),
                    valueColor: AlwaysStoppedAnimation(
                        PedidoProdutoStatus.pronto.color),
                  ),
                ],
              ),
            ],
          ),
        ),
        for (final produto in form.produtos)
          Column(
            children: [
              ExpansionTile(
                title: Row(
                  children: [
                    Text(
                        '${produto.produto.nome} - ${produto.produto.descricao}'),
                    const W(16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                          color: produto.statusess.last
                              .getStatusView()
                              .color
                              .withOpacity(0.4),
                          borderRadius: BorderRadius.circular(4)),
                      child: Text(produto.statusess.last.getStatusView().label,
                          style: AppCss.mediumRegular.setSize(12)),
                    )
                  ],
                ),
                childrenPadding: const EdgeInsets.all(16),
                subtitle: Text(
                  '${produto.qtde}Kg',
                  style: AppCss.minimumRegular,
                ),
                children: [
                  for (final status
                      in produto.statusess.map((e) => e.copyWith()).toList())
                    Builder(builder: (context) {
                      final isLast = status.id == produto.statusess.last.id;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: status
                                    .getStatusView()
                                    .color
                                    .withOpacity(isLast ? 0.4 : 0.2),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(status.getStatusView().label,
                                  style: AppCss.mediumRegular
                                      .setSize(14)
                                      .setColor(AppColors.black
                                          .withOpacity(isLast ? 1 : 0.4))),
                            ),
                            Text(status.createdAt.textHour(),
                                style: AppCss.minimumRegular.setColor(AppColors
                                    .black
                                    .withOpacity(isLast ? 1 : 0.4))),
                          ],
                        ),
                      );
                    })
                ],
              ),
              const Divisor(),
            ],
          ),
        const Divisor(),
        if (pedido.tipo == PedidoTipo.cda)
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Armação', style: AppCss.largeBold),
                const H(16),
                for (PedidoStatusModel status
                    in pedido.statusess.map((e) => e.copyWith()).toList())
                  Builder(builder: (context) {
                    final isLast = status.id == pedido.statusess.last.id;
                    if (status.status == PedidoStatus.produzindoCD) {
                      status.status = PedidoStatus.aguardandoProducaoCD;
                    }
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: status.status.color
                                  .withOpacity(isLast ? 0.4 : 0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(status.status.label,
                                style: AppCss.mediumRegular
                                    .setSize(14)
                                    .setColor(AppColors.black
                                        .withOpacity(isLast ? 1 : 0.4))),
                          ),
                          Text(status.createdAt.textHour(),
                              style: AppCss.minimumRegular.setColor(AppColors
                                  .black
                                  .withOpacity(isLast ? 1 : 0.4))),
                        ],
                      ),
                    );
                  })
              ],
            ),
          ),
      ],
    );
  }
}
