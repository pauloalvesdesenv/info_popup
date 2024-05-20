import 'package:aco_plus/app/core/client/firestore/collections/cliente/cliente_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/enums/pedido_tipo.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_model.dart';
import 'package:aco_plus/app/core/client/firestore/firestore_client.dart';
import 'package:aco_plus/app/core/components/app_drop_down.dart';
import 'package:aco_plus/app/core/components/app_scaffold.dart';
import 'package:aco_plus/app/core/components/divisor.dart';
import 'package:aco_plus/app/core/components/h.dart';
import 'package:aco_plus/app/core/components/stream_out.dart';
import 'package:aco_plus/app/core/components/w.dart';
import 'package:aco_plus/app/core/enums/sort_type.dart';
import 'package:aco_plus/app/core/extensions/date_ext.dart';
import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:aco_plus/app/modules/relatorio/relatorio_controller.dart';
import 'package:aco_plus/app/modules/relatorio/view_models/relatorio_pedido_view_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RelatoriosPedidoPage extends StatefulWidget {
  const RelatoriosPedidoPage({super.key});

  @override
  State<RelatoriosPedidoPage> createState() => _RelatoriosPedidoPageState();
}

class _RelatoriosPedidoPageState extends State<RelatoriosPedidoPage> {
  @override
  void initState() {
    relatorioCtrl.pedidoViewModelStream.add(RelatorioPedidoViewModel());
    relatorioCtrl.onCreateRelatorioPedido();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      resizeAvoid: true,
      appBar: AppBar(
        title: Text('Relatórios de Pedido',
            style: AppCss.largeBold.setColor(AppColors.white)),
        backgroundColor: AppColors.primaryMain,
        actions: [
          StreamOut(
            stream: relatorioCtrl.pedidoViewModelStream.listen,
            builder: (_, model) => IconButton(
              onPressed: model.relatorio != null
                  ? () => relatorioCtrl.onExportRelatorioPedidoPDF()
                  : null,
              icon: Icon(
                Icons.picture_as_pdf_outlined,
                color: model.relatorio != null ? null : Colors.grey[500],
              ),
            ),
          ),
        ],
      ),
      body: StreamOut(
        stream: relatorioCtrl.pedidoViewModelStream.listen,
        builder: (_, model) => ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  AppDropDown<ClienteModel?>(
                      label: 'Cliente',
                      item: model.cliente,
                      itens: [null, ...FirestoreClient.clientes.data],
                      itemLabel: (e) => e?.nome ?? 'TODOS',
                      onSelect: (e) {
                        model.cliente = e;
                        model.status = null;
                        relatorioCtrl.pedidoViewModelStream.add(model);
                        relatorioCtrl.onCreateRelatorioPedido();
                      }),
                  const H(16),
                  AppDropDown<RelatorioPedidoStatus?>(
                      label: 'Status',
                      item: model.status,
                      itens: const [null, ...RelatorioPedidoStatus.values],
                      itemLabel: (e) => e?.label ?? 'TODOS',
                      onSelect: (e) {
                        model.status = e;
                        relatorioCtrl.pedidoViewModelStream.add(model);
                        relatorioCtrl.onCreateRelatorioPedido();
                      }),
                  const H(16),
                  Row(
                    children: [
                      Expanded(
                        child: AppDropDown<SortType>(
                          label: 'Ordernar por',
                          item: model.sortType,
                          itens: model.sortTypes,
                          itemLabel: (e) => e.name,
                          onSelect: (e) {
                            model.sortType = e;
                            relatorioCtrl.pedidoViewModelStream.add(model);
                            relatorioCtrl.onCreateRelatorioPedido();
                          },
                        ),
                      ),
                      const W(16),
                      Expanded(
                        child: AppDropDown<SortOrder>(
                          label: 'Ordernar',
                          item: model.sortOrder,
                          itens: SortOrder.values,
                          itemLabel: (e) => e.name,
                          onSelect: (e) {
                            model.sortOrder = e;
                            relatorioCtrl.pedidoViewModelStream.add(model);
                            relatorioCtrl.onCreateRelatorioPedido();
                          },
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Divisor(color: Colors.grey[700]!, height: 1.5),
            Column(
              children: model.relatorio!.pedidos
                  .map((e) => itemRelatorio(e))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget itemRelatorio(PedidoModel pedido) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey[700]!, width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child: Text(pedido.localizador, style: AppCss.mediumBold)),
              Text(
                  DateFormat("'Criado 'dd/MM/yyyy' às 'HH:mm")
                      .format(pedido.createdAt),
                  style: AppCss.minimumRegular.setSize(11)),
            ],
          ),
          const Divisor(),
          itemInfo('Cliente', pedido.cliente.nome),
          const Divisor(),
          itemInfo('Descrição', pedido.obra.descricao),
          const Divisor(),
          itemInfo('Data de Entrega', pedido.deliveryAt != null ? pedido.deliveryAt.text() : 'Não definida'),
          const Divisor(),
          itemInfo('Tipo', pedido.tipo.label),
          const Divisor(),
          itemInfo(
              'Bitolas (mm)',
              pedido.produtos
                  .map((e) => e.produto.descricaoReplaced)
                  .join(', ')),
          const Divisor(),
          for (final produto in pedido.produtos)
            Column(
              children: [
                itemInfo('${produto.produto.descricaoReplaced}mm',
                    '${produto.qtde}Kg'),
                Divisor(
                  color: Colors.grey[200],
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget itemInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text('$label:',
                style: AppCss.minimumRegular
                    .copyWith(fontWeight: FontWeight.w500)),
          ),
          Expanded(
              flex: 2,
              child: Text(
                value,
                style: AppCss.minimumRegular.copyWith(),
                textAlign: TextAlign.end,
              ))
        ],
      ),
    );
  }
}
