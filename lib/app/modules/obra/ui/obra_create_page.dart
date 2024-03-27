import 'package:aco_plus/app/core/client/firestore/collections/cliente/cliente_model.dart';
import 'package:aco_plus/app/core/components/app_drop_down.dart';
import 'package:aco_plus/app/core/components/app_field.dart';
import 'package:aco_plus/app/core/components/app_scaffold.dart';
import 'package:aco_plus/app/core/components/done_button.dart';
import 'package:aco_plus/app/core/components/h.dart';
import 'package:aco_plus/app/core/components/stream_out.dart';
import 'package:aco_plus/app/core/enums/obra_status.dart';
import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:aco_plus/app/core/utils/global_resource.dart';
import 'package:aco_plus/app/modules/endereco/endereco_create_page.dart';
import 'package:aco_plus/app/modules/obra/obra_controller.dart';
import 'package:aco_plus/app/modules/obra/obra_view_model.dart';
import 'package:flutter/material.dart';

class ObraCreatePage extends StatefulWidget {
  final ObraModel? obra;
  const ObraCreatePage({this.obra, super.key});

  @override
  State<ObraCreatePage> createState() => _ObraCreatePageState();
}

class _ObraCreatePageState extends State<ObraCreatePage> {
  @override
  void initState() {
    obraCtrl.init(widget.obra);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
        resizeAvoid: true,
        appBar: AppBar(
          leading: IconButton(
              onPressed: () => pop(context),
              icon: Icon(
                Icons.arrow_back,
                color: AppColors.white,
              )),
          title: Text('${obraCtrl.form.isEdit ? 'Editar' : 'Adicionar'} Obra',
              style: AppCss.largeBold.setColor(AppColors.white)),
          actions: [IconLoadingButton(() async => await obraCtrl.onConfirm(context))],
          backgroundColor: AppColors.primaryMain,
        ),
        body: StreamOut(stream: obraCtrl.formStream.listen, child: (_, form) => body(form)));
  }

  Widget body(ObraCreateModel form) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        AppField(
          label: 'Descrição',
          controller: form.descricao,
          onChanged: (_) => obraCtrl.formStream.update(),
        ),
        const H(16),
        AppDropDown<ObraStatus?>(
          label: 'Status',
          item: form.status,
          itens: ObraStatus.values,
          itemLabel: (e) => e?.label ?? 'Selecione um status',
          onSelect: (e) {
            form.status = e;
            obraCtrl.formStream.update();
          },
        ),
        const H(16),
        InkWell(
          onTap: () async {
            final endereco = await push(context, EnderecoCreatePage(endereco: form.endereco));
            if (endereco != null) {
              form.endereco = endereco;
              obraCtrl.formStream.update();
            }
          },
          child: IgnorePointer(
            child: AppField(
              label: 'Endereço',
              suffixIconSize: 12,
              suffixIcon: Icons.arrow_forward_ios,
              controller: TextEditingController(text: form.endereco?.name.toString() ?? ''),
              onChanged: (_) => obraCtrl.formStream.update(),
            ),
          ),
        ),
      ],
    );
  }
}
