import 'package:aco_plus/app/core/client/firestore/collections/ordem/models/ordem_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/produto/produto_model.dart';
import 'package:aco_plus/app/core/client/firestore/firestore_client.dart';
import 'package:aco_plus/app/core/components/app_drop_down.dart';
import 'package:aco_plus/app/core/components/app_scaffold.dart';
import 'package:aco_plus/app/core/components/done_button.dart';
import 'package:aco_plus/app/core/components/h.dart';
import 'package:aco_plus/app/core/components/stream_out.dart';
import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:aco_plus/app/core/utils/global_resource.dart';
import 'package:aco_plus/app/modules/ordem/ordem_controller.dart';
import 'package:aco_plus/app/modules/ordem/view_models/ordem_view_model.dart';
import 'package:flutter/material.dart';

class OrdemCreatePage extends StatefulWidget {
  final OrdemModel? ordem;
  const OrdemCreatePage({this.ordem, super.key});

  @override
  State<OrdemCreatePage> createState() => _OrdemCreatePageState();
}

class _OrdemCreatePageState extends State<OrdemCreatePage> {
  @override
  void initState() {
    ordemCtrl.onInitCreatePage(widget.ordem);
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
          title: Text('${ordemCtrl.form.isEdit ? 'Editar' : 'Adicionar'} Ordem',
              style: AppCss.largeBold.setColor(AppColors.white)),
          actions: [
            IconLoadingButton(() async =>
                await ordemCtrl.onConfirm(context, widget.ordem, false))
          ],
          backgroundColor: AppColors.primaryMain,
        ),
        body: StreamOut(
            stream: ordemCtrl.formStream.listen,
            child: (_, form) => body(form)));
  }

  Widget body(OrdemCreateModel form) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        AppDropDown<ProdutoModel?>(
          label: 'Produto',
          item: form.produto,
          itens: FirestoreClient.produtos.data,
          disable: form.produtos.isNotEmpty,
          itemLabel: (e) => e!.descricao,
          onSelect: (e) {
            form.produto = e;
            ordemCtrl.formStream.update();
          },
        ),
        const H(16),
        if (form.produto != null)
          for (var produto in ordemCtrl.getPedidosPorProduto(form.produto!))
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [Text(produto.produto.nome)],
                    ),
                  ),
                ],
              ),
            )

        // AppDropDown<ClienteModel?>(
        //   label: 'Cliente',
        //   item: form.cliente,
        //   disable: form.produto == null,
        //   itens: ordemCtrl.getClientesByProduto(form.produto),
        //   itemLabel: (e) => e!.nome,
        //   onSelect: (e) {
        //     form.cliente = e;
        //     ordemCtrl.formStream.update();
        //   },
        // ),
        // const H(16),
        // AppDropDown<ObraModel?>(
        //   label: 'Obra',
        //   item: form.obra,
        //   disable: form.cliente == null,
        //   itens: ordemCtrl.getObrasByClienteAndProduto(form.cliente, form.produto),
        //   itemLabel: (e) => e!.descricao,
        //   onSelect: (e) {
        //     form.obra = e;
        //     ordemCtrl.formStream.update();
        //   },
        // ),
        // const H(16),
        // AppDropDown<PedidoProdutoModel?>(
        //   label: 'Pedido',
        //   item: form.produtoPedido,
        //   disable: form.obra == null,
        //   itens: ordemCtrl.getProduto(form.cliente, form.obra, form.produto),
        //   itemLabel: (e) => '${'${e!.produto.nome} ${e.produto.descricao}'} - ${e.qtde}Kg',
        //   onSelect: (e) {
        //     form.produtoPedido = e;
        //     ordemCtrl.formStream.update();
        //   },
        // ),
        // const H(16),
        // AppTextButton(
        //   isEnable: form.produtoPedido != null,
        //   label: 'Adicionar',
        //   onPressed: () {
        //     form.produtos.add(form.produtoPedido!);
        //     form.cliente = null;
        //     form.obra = null;
        //     form.produtoPedido = null;
        //     ordemCtrl.formStream.update();
        //   },
        // ),
        // for (PedidoProdutoModel pedidoProduto in form.produtos)
        //   Builder(builder: (_) {
        //     final cliente = FirestoreClient.clientes.getById(pedidoProduto.clienteId);
        //     return ListTile(
        //       leading: Text((form.produtos.indexOf(pedidoProduto) + 1).toString(),
        //           style: AppCss.mediumBold),
        //       minLeadingWidth: 14,
        //       contentPadding: const EdgeInsets.only(left: 16),
        //       title: Text(
        //           '${'${pedidoProduto.produto.nome} ${pedidoProduto.produto.descricao}'} - ${pedidoProduto.qtde}Kg'),
        //       subtitle: Text(
        //           '${cliente.nome} - ${cliente.obras.firstWhere((e) => e.id == pedidoProduto.obraId).descricao}'),
        //       trailing: IconButton(
        //         onPressed: () {
        //           form.produtos.remove(pedidoProduto);
        //           ordemCtrl.formStream.update();
        //         },
        //         icon: const Icon(
        //           Icons.delete,
        //           color: Colors.red,
        //         ),
        //       ),
        //     );
        //   }),
      ],
    );
  }
}
