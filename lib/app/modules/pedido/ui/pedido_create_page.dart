import 'package:aco_plus/app/core/client/firestore/collections/cliente/cliente_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/enums/pedido_tipo.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/produto/produto_model.dart';
import 'package:aco_plus/app/core/client/firestore/firestore_client.dart';
import 'package:aco_plus/app/core/components/app_drop_down.dart';
import 'package:aco_plus/app/core/components/app_field.dart';
import 'package:aco_plus/app/core/components/app_scaffold.dart';
import 'package:aco_plus/app/core/components/done_button.dart';
import 'package:aco_plus/app/core/components/h.dart';
import 'package:aco_plus/app/core/components/stream_out.dart';
import 'package:aco_plus/app/core/components/w.dart';
import 'package:aco_plus/app/core/dialogs/confirm_dialog.dart';
import 'package:aco_plus/app/core/enums/obra_status.dart';
import 'package:aco_plus/app/core/formatters/uper_case_formatter.dart';
import 'package:aco_plus/app/core/services/notification_service.dart';
import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:aco_plus/app/core/utils/global_resource.dart';
import 'package:aco_plus/app/modules/cliente/ui/cliente_create_simplify_bottom.dart';
import 'package:aco_plus/app/modules/pedido/pedido_controller.dart';
import 'package:aco_plus/app/modules/pedido/view_models/pedido_produto_view_model.dart';
import 'package:aco_plus/app/modules/pedido/view_models/pedido_view_model.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

class PedidoCreatePage extends StatefulWidget {
  final PedidoModel? pedido;
  const PedidoCreatePage({this.pedido, super.key});

  @override
  State<PedidoCreatePage> createState() => _PedidoCreatePageState();
}

class _PedidoCreatePageState extends State<PedidoCreatePage> {
  final FocusNode focusQtde = FocusNode();
  @override
  void initState() {
    pedidoCtrl.onInitCreatePage(widget.pedido);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      resizeAvoid: true,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () async {
              if (await showConfirmDialog(
                  'Deseja realmente sair?', 'Os dados do pedido serão perdidos.')) {
                pop(context);
              }
            },
            icon: Icon(
              Icons.arrow_back,
              color: AppColors.white,
            )),
        title: Text('${pedidoCtrl.form.isEdit ? 'Editar' : 'Adicionar'} Pedido',
            style: AppCss.largeBold.setColor(AppColors.white)),
        actions: [
          IconLoadingButton(() async => await pedidoCtrl.onConfirm(context, widget.pedido, false))
        ],
        backgroundColor: AppColors.primaryMain,
      ),
      body: StreamOut(stream: pedidoCtrl.formStream.listen, builder: (_, form) => body(form)),
    );
  }

  Widget body(PedidoCreateModel form) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        AppField(
          label: 'Localizador',
          inputFormatters: [UpperCaseFormatter()],
          capitalization: TextCapitalization.characters,
          controller: form.localizador,
          type: TextInputType.name,
          action: TextInputAction.next,
          onChanged: (_) => pedidoCtrl.formStream.update(),
          onEditingComplete: () {
            if (form.localizador.text.isEmpty) {
              NotificationService.showNegative('Localizador não pode ser vazio',
                  'Não será possível salvar o pedido sem um localizador',
                  position: NotificationPosition.bottom);
            } else {
              FocusScope.of(context).unfocus();
            }
          },
        ),
        const H(16),
        AppDropDown<PedidoTipo?>(
          label: 'Tipo',
          item: form.tipo,
          itens: PedidoTipo.values,
          itemLabel: (e) => e!.label,
          onSelect: (e) {
            form.tipo = e;
            pedidoCtrl.formStream.update();
          },
        ),
        const H(16),
        AppField(
          label: 'Descrição',
          controller: form.descricao,
          onChanged: (_) => pedidoCtrl.formStream.update(),
        ),
        const H(16),
        AppDropDown<ClienteModel?>(
          label: 'Cliente',
          disable: form.isEdit,
          item: form.cliente,
          itens: [
            ClienteAdd(),
            if (form.clienteAdd != null) form.clienteAdd,
            ...FirestoreClient.clientes.data
          ],
          itemLabel: (e) => e?.nome ?? 'ADICIONAR CLIENTE',
          onSelect: (e) async {
            if (e?.id == 'add') {
              final created = await showClienteCreateSimplifyBottom();
              if (created != null) {
                form.clienteAdd = created;
                form.cliente = created;
                form.obra = form.cliente!.obras.first;
                pedidoCtrl.formStream.update();
              }
            } else {
              form.cliente = e;
            }
            pedidoCtrl.formStream.update();
          },
        ),
        const H(16),
        AppDropDown<ObraModel?>(
          label: 'Obra',
          item: form.obra,
          disable: form.isEdit ? form.isEdit : form.cliente == null,
          itens:
              form.cliente?.obras.where((e) => e.status == ObraStatus.emAndamento).toList() ?? [],
          itemLabel: (e) => e!.descricao,
          onSelect: (e) {
            form.obra = e;
            pedidoCtrl.formStream.update();
          },
        ),
        const H(16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                children: [
                  AppDropDown<ProdutoModel?>(
                    label: 'Produto',
                    item: form.produto.produtoModel,
                    itens: FirestoreClient.produtos.data
                        .where((e) => !form.produtos.map((e) => e.produtoModel?.id).contains(e.id))
                        .toList(),
                    itemLabel: (e) => e?.descricao ?? 'Selecione',
                    onSelect: (e) {
                      form.produto.produtoModel = e;
                      pedidoCtrl.formStream.update();
                    },
                  ),
                  const H(6),
                  AppField(
                    label: 'Quantidade',
                    type: const TextInputType.numberWithOptions(decimal: true, signed: false),
                    controller: form.produto.qtde,
                    action: TextInputAction.done,
                    suffixText: 'Kg',
                    onChanged: (_) => pedidoCtrl.formStream.update(),
                    onEditingComplete: () {
                      if (form.produto.isEnable) {
                        FocusScope.of(context).unfocus();
                        form.produtos.add(form.produto);
                        form.produto = PedidoProdutoCreateModel();
                        pedidoCtrl.formStream.update();
                      }
                    },
                  ),
                ],
              ),
            ),
            const W(8),
            Padding(
              padding: const EdgeInsets.only(top: 28),
              child: IconButton(
                onPressed: !form.produto.isEnable
                    ? null
                    : () {
                        FocusScope.of(context).unfocus();
                        form.produtos.add(form.produto);
                        form.produto = PedidoProdutoCreateModel();
                        pedidoCtrl.formStream.update();
                      },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(form.produto.isEnable
                      ? AppColors.primaryMain
                      : AppColors.black.withOpacity(0.3)),
                ),
                icon: Icon(
                  Icons.add,
                  color: AppColors.white,
                ),
              ),
            ),
          ],
        ),
        for (PedidoProdutoCreateModel produto in form.produtos)
          Builder(builder: (context) {
            bool isDisabled = form.isEdit &&
                FirestoreClient.ordens.data
                    .expand((e) => e.produtos.map((e) => e.produto.id))
                    .any((e) => e == produto.produtoModel?.id);
            return IgnorePointer(
              ignoring: isDisabled,
              child: Container(
                color: isDisabled ? Colors.grey[300] : Colors.transparent,
                child: ListTile(
                  leading: Text((form.produtos.indexOf(produto) + 1).toString(),
                      style: AppCss.mediumBold),
                  minLeadingWidth: 14,
                  contentPadding: const EdgeInsets.only(left: 16),
                  title: Row(
                    children: [
                      Text(produto.produtoModel?.descricao ?? ''),
                      if (isDisabled)
                        Text(' Produto já foi adicionado há uma ordem',
                            style: AppCss.mediumRegular.setColor(Colors.red[500]!).setSize(11))
                    ],
                  ),
                  subtitle: Text('Quantidade: ${produto.qtde.text} Kg'),
                  trailing: isDisabled
                      ? null
                      : IconButton(
                          onPressed: () {
                            form.produtos.remove(produto);
                            pedidoCtrl.formStream.update();
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        ),
                ),
              ),
            );
          })
      ],
    );
  }
}
