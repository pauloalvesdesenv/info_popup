import 'package:aco_plus/app/core/client/firestore/collections/pedido/enums/pedido_status.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/enums/pedido_tipo.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_produto_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_produto_status_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_status_model.dart';
import 'package:aco_plus/app/core/components/archive/ui/archives_widget.dart';
import 'package:aco_plus/app/core/components/checklist/check_list_widget.dart';
import 'package:aco_plus/app/core/components/comment/ui/comments_widget.dart';
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
import 'package:aco_plus/app/modules/pedido/pedido_controller.dart';
import 'package:flutter/material.dart';

class PedidoMinifyPage extends StatefulWidget {
  final PedidoModel pedido;
  final Function() onDelete;
  const PedidoMinifyPage(this.pedido, this.onDelete, {super.key});

  @override
  State<PedidoMinifyPage> createState() => _PedidoMinifyPageState();
}

class _PedidoMinifyPageState extends State<PedidoMinifyPage> {
  @override
  void initState() {
    pedidoCtrl.onInitPage(widget.pedido);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamOut(
      stream: pedidoCtrl.pedidoStream.listen,
      builder: (_, form) => Material(
        child: body(form),
      ),
    );
  }

  Widget body(PedidoModel form) {
    return SizedBox(
      height: double.maxFinite,
      child: ListView(
        children: [
          Container(
              width: double.maxFinite,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(color: AppColors.primaryMain),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => widget.onDelete(),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                  ),
                  const W(16),
                  Text(
                    pedido.localizador,
                    style: AppCss.largeBold.setColor(Colors.white).setSize(18),
                  ),
                ],
              )),
          _descWidget(form),
          const Divisor(),
          _stepWidget(),
          const Divisor(),
          _statusWidget(),
          const Divisor(),
          _corteDobraWidget(form),
          const Divisor(),
          _produtosWidget(form),
          const Divisor(),
          if (pedido.tipo == PedidoTipo.cda) ...[
            _armacaoWidget(),
            const Divisor()
          ],
          _anexosWidget(form),
          const Divisor(),
          _checksWidget(form),
          const Divisor(),
          _commentsWidget(form)
        ],
      ),
    );
  }

  Column _produtosWidget(PedidoModel form) {
    return Column(
      children:
          form.produtos.map((produto) => _produtoWidget(produto)).toList(),
    );
  }

  Column _produtoWidget(PedidoProdutoModel produto) {
    return Column(
      children: [
        ExpansionTile(
          title: Row(
            children: [
              Text('${produto.produto.nome} - ${produto.produto.descricao}'),
              const W(16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
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
                            style: AppCss.mediumRegular.setSize(14).setColor(
                                AppColors.black.withOpacity(isLast ? 1 : 0.4))),
                      ),
                      Text(status.createdAt.textHour(),
                          style: AppCss.minimumRegular.setColor(
                              AppColors.black.withOpacity(isLast ? 1 : 0.4))),
                    ],
                  ),
                );
              })
          ],
        ),
        const Divisor(),
      ],
    );
  }

  Container _armacaoWidget() {
    return Container(
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
                        color:
                            status.status.color.withOpacity(isLast ? 0.4 : 0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(status.status.label,
                          style: AppCss.mediumRegular.setSize(14).setColor(
                              AppColors.black.withOpacity(isLast ? 1 : 0.4))),
                    ),
                    Text(status.createdAt.textHour(),
                        style: AppCss.minimumRegular.setColor(
                            AppColors.black.withOpacity(isLast ? 1 : 0.4))),
                  ],
                ),
              );
            })
        ],
      ),
    );
  }

  Padding _corteDobraWidget(PedidoModel form) {
    return Padding(
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
                backgroundColor: PedidoProdutoStatus.aguardandoProducao.color
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
                      child: Text('Produzindo', style: AppCss.mediumRegular)),
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
                  Expanded(child: Text('Pronto', style: AppCss.mediumRegular)),
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
                valueColor:
                    AlwaysStoppedAnimation(PedidoProdutoStatus.pronto.color),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Container _statusWidget() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(child: Text('Status do Pedido', style: AppCss.largeBold)),
          InkWell(
            onTap: pedido.isChangeStatusAvailable
                ? () => pedidoCtrl.onChangePedidoStatus(pedido)
                : null,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              decoration: BoxDecoration(
                  color: pedido.statusess.last.status.color.withOpacity(0.4),
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
    );
  }

  Container _stepWidget() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(child: Text('Etapa do Pedido', style: AppCss.largeBold)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
            decoration: BoxDecoration(
                color: pedido.step.color.withOpacity(0.4),
                borderRadius: BorderRadius.circular(4)),
            child:
                Text(pedido.step.name, style: AppCss.mediumRegular.setSize(12)),
          )
        ],
      ),
    );
  }

  Padding _descWidget(PedidoModel form) {
    return Padding(
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
    );
  }

  Container _anexosWidget(PedidoModel form) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: ArchivesWidget(
        path: 'pedidos/${form.id}',
        archives: form.archives,
        onChanged: () => pedidoCtrl.updatePedidoFirestore(),
      ),
    );
  }

  Container _checksWidget(PedidoModel form) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CheckListWidget(
            items: form.checks,
            onChanged: () => pedidoCtrl.updatePedidoFirestore(),
          ),
        ],
      ),
    );
  }

  Container _commentsWidget(PedidoModel form) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StreamOut(
            stream: pedidoCtrl.utilsStream.listen,
            builder: (_, utils) => CommentsWidget(
              quill: utils.quill,
              items: form.comments,
              onChanged: () => pedidoCtrl.updatePedidoFirestore(),
            ),
          ),
        ],
      ),
    );
  }
}
