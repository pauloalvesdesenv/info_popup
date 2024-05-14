import 'package:aco_plus/app/core/client/firestore/collections/ordem/models/ordem_model.dart';
import 'package:aco_plus/app/core/components/app_drop_down.dart';
import 'package:aco_plus/app/core/components/app_field.dart';
import 'package:aco_plus/app/core/components/app_scaffold.dart';
import 'package:aco_plus/app/core/components/app_text_button.dart';
import 'package:aco_plus/app/core/components/divisor.dart';
import 'package:aco_plus/app/core/components/h.dart';
import 'package:aco_plus/app/core/components/stream_out.dart';
import 'package:aco_plus/app/core/components/type_selector_widget.dart';
import 'package:aco_plus/app/core/models/text_controller.dart';
import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:aco_plus/app/core/utils/global_resource.dart';
import 'package:aco_plus/app/modules/relatorio/relatorio_controller.dart';
import 'package:aco_plus/app/modules/relatorio/view_models/relatorio_ordem_view_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RelatoriosOrdemPage extends StatefulWidget {
  const RelatoriosOrdemPage({super.key});

  @override
  State<RelatoriosOrdemPage> createState() => _RelatoriosOrdemPageState();
}

class _RelatoriosOrdemPageState extends State<RelatoriosOrdemPage> {
  @override
  void initState() {
    relatorioCtrl.ordemViewModelStream.add(RelatorioOrdemViewModel());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      resizeAvoid: true,
      appBar: AppBar(
        title: Text('Relatórios de Ordem',
            style: AppCss.largeBold.setColor(AppColors.white)),
        backgroundColor: AppColors.primaryMain,
        actions: [
          StreamOut(
            stream: relatorioCtrl.ordemViewModelStream.listen,
            builder: (_, model) => IconButton(
              onPressed: model.relatorio != null
                  ? () => relatorioCtrl.onExportRelatorioOrdemPDF()
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
        stream: relatorioCtrl.ordemViewModelStream.listen,
        builder: (_, model) => ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TypeSelectorWidget<RelatorioOrdemType?>(
                    label: 'Selecione o modelo de relatório',
                    values: RelatorioOrdemType.values,
                    value: relatorioCtrl.ordemViewModel.type,
                    onChanged: (e) {
                      model.ordem = null;
                      model.status = null;
                      model.dates = null;
                      model.relatorio = null;
                      model.type = e;
                      relatorioCtrl.ordemViewModelStream.add(model);
                    },
                    itemLabel: (e) => e?.label ?? 'SELECIONE O MODELO',
                  ),
                  if (model.type == RelatorioOrdemType.ORDEM) ...{
                    Row(
                      children: [
                        Expanded(
                          flex: 4,
                          child: AppField(
                            required: false,
                            label: 'Ordem única',
                            controller: model.ordemEC,
                            onEditingComplete: () =>
                                relatorioCtrl.onSearchRelatorio(),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 23, left: 12),
                            child: AppTextButton(
                              label: 'Buscar',
                              onPressed: () =>
                                  relatorioCtrl.onSearchRelatorio(),
                            ),
                          ),
                        )
                      ],
                    ),
                    const H(16),
                  },
                  if (model.type == RelatorioOrdemType.STATUS) ...{
                    AppDropDown<RelatorioOrdemStatus?>(
                        label: 'Status',
                        item: model.status,
                        itens: RelatorioOrdemStatus.values,
                        itemLabel: (e) => e?.label ?? 'SELECIONE O STATUS',
                        onSelect: (e) {
                          model.status = e;
                          relatorioCtrl.ordemViewModelStream.add(model);
                          relatorioCtrl.onCreateRelatorio();
                        }),
                    const H(16),
                    InkWell(
                      onTap: () async {
                        final dates = await showDateRangePicker(
                          context: contextGlobal,
                          firstDate: DateTime(2010),
                          lastDate: DateTime(2030),
                        );
                        if (dates == null) return;
                        model.dates = dates;
                        relatorioCtrl.ordemViewModelStream.update();
                        relatorioCtrl.onCreateRelatorio();
                        setState(() {});
                      },
                      child: Stack(
                        children: [
                          IgnorePointer(
                            ignoring: true,
                            child: AppField(
                              required: false,
                              label: 'Datas: (Opcional)',
                              controller: TextController(
                                  text: model.dates != null
                                      ? ([model.dates!.start, model.dates!.end]
                                          .map((e) =>
                                              DateFormat('dd/MM/yyy').format(e))
                                          .join(' até '))
                                      : 'Selecione'),
                            ),
                          ),
                          if (model.dates != null)
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Container(
                                padding: const EdgeInsets.only(top: 26),
                                child: IconButton(
                                  onPressed: () {
                                    model.dates = null;
                                    relatorioCtrl.onExportRelatorioPedidoPDF();
                                    relatorioCtrl.ordemViewModelStream.update();
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Colors.transparent),
                                    foregroundColor:
                                        MaterialStateProperty.all(Colors.black),
                                  ),
                                  icon: Icon(Icons.close,
                                      color: Colors.grey[500]),
                                ),
                              ),
                            )
                        ],
                      ),
                    ),
                  },
                ],
              ),
            ),
            Divisor(color: Colors.grey[700]!, height: 1.5),
            if (model.relatorio != null)
              Column(
                children: [
                  if (model.type == RelatorioOrdemType.ORDEM)
                    model.relatorio!.ordem,
                  if (model.type == RelatorioOrdemType.STATUS)
                    ...model.relatorio!.ordens
                ].map((e) => itemRelatorio(e)).toList(),
              ),
            if (model.type == RelatorioOrdemType.STATUS &&
                model.relatorio != null) ...[
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Totais',
                  style: AppCss.mediumBold,
                ),
              ),
              for (final produto in relatorioCtrl.getOrdemTotalProduto())
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: itemInfo(
                          produto.produto.descricao, '${produto.qtde} Kg'),
                    ),
                    const Divisor(),
                  ],
                ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: itemInfo(
                    'Total Geral', '${relatorioCtrl.getOrdemTotal()} Kg'),
              ),
            ]
          ],
        ),
      ),
    );
  }

  Widget itemRelatorio(OrdemModel ordem) {
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
              Expanded(child: Text(ordem.id, style: AppCss.mediumBold)),
              Text(
                  DateFormat("'Criado 'dd/MM/yyyy' às 'HH:mm")
                      .format(ordem.createdAt),
                  style: AppCss.minimumRegular.setSize(11)),
            ],
          ),
          itemInfo('Bitola', '${ordem.produto.descricaoReplaced}mm'),
          const Divisor(),
          for (final produto in ordem.produtos)
            Column(
              children: [
                itemInfo(
                    '${produto.pedido.localizador} - ${produto.cliente.nome} - ${produto.obra.descricao}',
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
