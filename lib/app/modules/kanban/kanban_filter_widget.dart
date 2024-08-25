import 'package:aco_plus/app/core/client/firestore/collections/cliente/cliente_model.dart';
import 'package:aco_plus/app/core/client/firestore/firestore_client.dart';
import 'package:aco_plus/app/core/components/app_drop_down.dart';
import 'package:aco_plus/app/core/components/app_field.dart';
import 'package:aco_plus/app/core/components/h.dart';
import 'package:aco_plus/app/core/components/stream_out.dart';
import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:aco_plus/app/modules/kanban/kanban_controller.dart';
import 'package:aco_plus/app/modules/kanban/kanban_view_model.dart';
import 'package:flutter/material.dart';

class KanbanFilterWidget extends StatefulWidget {
  final KanbanUtils utils;
  const KanbanFilterWidget(this.utils, {super.key});

  @override
  State<KanbanFilterWidget> createState() => _KanbanFilterWidgetState();
}

class _KanbanFilterWidgetState extends State<KanbanFilterWidget> {
  @override
  void initState() {
    widget.utils.search.focus.requestFocus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamOut(
      stream: kanbanCtrl.utilsStream.listen,
      builder: (_, utils) => ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: 300,
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: AppColors.primaryDark),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                width: double.maxFinite,
                decoration: BoxDecoration(
                  color: AppColors.primaryMain,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text('Filtros:',
                          style: AppCss.mediumBold.setColor(Colors.white)),
                    ),
                    InkWell(
                      onTap: () {
                        widget.utils.controller.dismissInfoPopup();
                      },
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    AppField(
                        autoFocus: true,
                        controller: utils.search,
                        hint: 'Buscar localizador',
                        onChanged: (_) {
                          kanbanCtrl.utilsStream.update();
                        }),
                    const H(8),
                    AppDropDown<ClienteModel?>(
                      controller: utils.clienteEC,
                      hasFilter: true,
                      hint: 'Selecionar Cliente',
                      item: utils.cliente,
                      itens: FirestoreClient.clientes.data,
                      itemLabel: (e) => e?.nome ?? 'Selecionar cliente',
                      onSelect: (e) {
                        utils.cliente = e;
                        kanbanCtrl.utilsStream.update();
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
