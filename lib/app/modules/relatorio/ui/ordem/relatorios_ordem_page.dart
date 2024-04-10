import 'package:aco_plus/app/core/client/firestore/collections/ordem/models/ordem_model.dart';
import 'package:aco_plus/app/core/components/app_drop_down.dart';
import 'package:aco_plus/app/core/components/app_field.dart';
import 'package:aco_plus/app/core/components/app_scaffold.dart';
import 'package:aco_plus/app/core/components/divisor.dart';
import 'package:aco_plus/app/core/components/h.dart';
import 'package:aco_plus/app/core/components/stream_out.dart';
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
        title: Text('Relatórios de Ordem', style: AppCss.largeBold.setColor(AppColors.white)),
        backgroundColor: AppColors.primaryMain,
        actions: [
          StreamOut(
            stream: relatorioCtrl.ordemViewModelStream.listen,
            builder: (_, model) => IconButton(
              onPressed:
                  model.relatorio != null ? () => relatorioCtrl.onExportRelatorioOrdemPDF() : null,
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
                  AppDropDown<RelatorioOrdemStatus?>(
                      label: 'Status',
                      item: model.status,
                      itens: RelatorioOrdemStatus.values,
                      itemLabel: (e) => e?.label ?? 'SELECIONE O STATUS',
                      onSelect: (e) {
                        model.status = e;
                        relatorioCtrl.ordemViewModelStream.add(model);
                        relatorioCtrl.onCreateRelatorioOrdem();
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
                      relatorioCtrl.onCreateRelatorioOrdem();
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
                                        .map((e) => DateFormat('dd/MM/yyy').format(e))
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
                                  backgroundColor: MaterialStateProperty.all(Colors.transparent),
                                  foregroundColor: MaterialStateProperty.all(Colors.black),
                                ),
                                icon: Icon(Icons.close, color: Colors.grey[500]),
                              ),
                            ),
                          )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divisor(color: Colors.grey[700]!, height: 1.5),
            if (model.relatorio != null)
              Column(
                children: model.relatorio!.ordens.map((e) => itemRelatorio(e)).toList(),
              ),
            if (model.relatorio != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: itemInfo('Total', '${relatorioCtrl.getOrdemTotal()} Kg'),
              ),
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
              Text(DateFormat("'Criado 'dd/MM/yyyy' às 'HH:mm").format(ordem.createdAt),
                  style: AppCss.minimumRegular.setSize(11)),
            ],
          ),
          itemInfo('Bitola', '${ordem.produto.descricaoReplaced}mm'),
          const Divisor(),
          for (final produto in ordem.produtos)
            Column(
              children: [
                itemInfo(
                    '${produto.cliente.nome} - ${produto.obra.descricao}', '${produto.qtde}Kg'),
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
            child:
                Text('$label:', style: AppCss.minimumRegular.copyWith(fontWeight: FontWeight.w500)),
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
