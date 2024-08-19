import 'package:aco_plus/app/core/client/firestore/collections/ordem/models/ordem_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_produto_status_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/produto/produto_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/usuario/enums/user_permission_type.dart';
import 'package:aco_plus/app/core/client/firestore/firestore_client.dart';
import 'package:aco_plus/app/core/components/app_drawer.dart';
import 'package:aco_plus/app/core/components/app_drop_down.dart';
import 'package:aco_plus/app/core/components/app_drop_down_list.dart';
import 'package:aco_plus/app/core/components/app_field.dart';
import 'package:aco_plus/app/core/components/app_scaffold.dart';
import 'package:aco_plus/app/core/components/empty_data.dart';
import 'package:aco_plus/app/core/components/h.dart';
import 'package:aco_plus/app/core/components/stream_out.dart';
import 'package:aco_plus/app/core/components/w.dart';
import 'package:aco_plus/app/core/extensions/date_ext.dart';
import 'package:aco_plus/app/core/extensions/double_ext.dart';
import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:aco_plus/app/core/utils/global_resource.dart';
import 'package:aco_plus/app/modules/base/base_controller.dart';
import 'package:aco_plus/app/modules/ordem/ordem_controller.dart';
import 'package:aco_plus/app/modules/ordem/ui/ordem_create_page.dart';
import 'package:aco_plus/app/modules/ordem/ui/ordem_page.dart';
import 'package:aco_plus/app/modules/ordem/view_models/ordem_view_model.dart';
import 'package:aco_plus/app/modules/usuario/usuario_controller.dart';
import 'package:flutter/material.dart';

class OrdensPage extends StatefulWidget {
  const OrdensPage({super.key});

  @override
  State<OrdensPage> createState() => _OrdensPageState();
}

class _OrdensPageState extends State<OrdensPage> {
  @override
  void initState() {
    ordemCtrl.onInit();
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
        title:
            Text('Ordens', style: AppCss.largeBold.setColor(AppColors.white)),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.domain_verification,
                color: AppColors.white,
              )),
          IconButton(
              onPressed: () {
                setState(() {
                  ordemCtrl.utils.showFilter = !ordemCtrl.utils.showFilter;
                  ordemCtrl.utilsStream.update();
                });
              },
              icon: Icon(
                Icons.sort,
                color: AppColors.white,
              )),
          if (usuario.permission.ordem.contains(UserPermissionType.create))
            IconButton(
                onPressed: () => push(context, const OrdemCreatePage()),
                icon: Icon(
                  Icons.add,
                  color: AppColors.white,
                ))
        ],
        backgroundColor: AppColors.primaryMain,
      ),
      body: StreamOut<List<OrdemModel>>(
        stream: FirestoreClient.ordens.dataStream.listen,
        builder: (_, __) => StreamOut<OrdemUtils>(
          stream: ordemCtrl.utilsStream.listen,
          builder: (_, utils) {
            List<OrdemModel> ordens = ordemCtrl
                .getOrdensFiltered(
                    utils.search.text,
                    __
                        .where((e) => e.status != PedidoProdutoStatus.pronto)
                        .toList())
                .toList();
            if (utils.status.isNotEmpty) {
              ordens =
                  ordens.where((e) => utils.status.contains(e.status)).toList();
            }
            if (utils.produto != null) {
              ordens = ordens
                  .where((e) => e.produto.id == utils.produto!.id)
                  .toList();
            }

            ordens.sort((a, b) {
              if (a.beltIndex == null && b.beltIndex == null) {
                return 0;
              } else if (a.beltIndex == null) {
                return 1;
              } else if (b.beltIndex == null) {
                return -1;
              } else {
                return a.beltIndex!.compareTo(b.beltIndex!);
              }
            });

            return RefreshIndicator(
              onRefresh: () async => FirestoreClient.ordens.fetch(),
              child: ListView(
                children: [
                  if (utils.showFilter)
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          AppField(
                            hint: 'Pesquisar',
                            controller: utils.search,
                            suffixIcon: Icons.search,
                            onChanged: (_) => ordemCtrl.utilsStream.update(),
                          ),
                          const H(16),
                          AppDropDown<ProdutoModel?>(
                            label: 'Bitola',
                            item: utils.produto,
                            itens: FirestoreClient.produtos.data.toList(),
                            itemLabel: (e) => e != null
                                ? e.descricao
                                : 'Selecione um produto',
                            onSelect: (e) {
                              utils.produto = e;
                              ordemCtrl.utilsStream.update();
                            },
                          ),
                          const H(16),
                          AppDropDownList<PedidoProdutoStatus>(
                            label: 'Ordernar por',
                            addeds: utils.status,
                            itens: const [
                              PedidoProdutoStatus.aguardandoProducao,
                              PedidoProdutoStatus.produzindo,
                            ],
                            itemLabel: (e) => e.label,
                            itemColor: (e) => e.color,
                            onChanged: () {
                              ordemCtrl.utilsStream.update();
                            },
                          ),
                        ],
                      ),
                    ),
                  ordens.isEmpty
                      ? const EmptyData()
                      : ReorderableListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          cacheExtent: 200,
                          itemCount: ordens.length,
                          // separatorBuilder: (_, i) => const Divisor(),
                          onReorder: (oldIndex, newIndex) {
                            setState(() {
                              ordemCtrl.reorderOrdens(
                                  ordens, oldIndex, newIndex);
                            FirestoreClient.ordens.updateAll(ordens);
                            });
                          },
                          itemBuilder: (_, i) => _itemOrdemWidget(ordens[i]),
                        )
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _itemOrdemWidget(OrdemModel ordem) {
    return InkWell(
      key: ValueKey(ordem.id),
      onTap: () => push(OrdemPage(ordem.id)),
      child: Container(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
        ),
        child: Stack(
          children: [
            ColorFiltered(
              colorFilter: ColorFilter.mode(
                  ordem.freezed.isFreezed
                      ? Colors.grey[500]!
                      : Colors.transparent,
                  BlendMode.saturation),
              child: Container(
                color:
                    ordem.freezed.isFreezed ? Colors.grey[200]! : Colors.white,
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(ordem.icon),
                    const W(16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ordem.id,
                            style: AppCss.mediumBold,
                          ),
                          Text(
                            '${ordem.produto.nome} ${ordem.produto.descricao} - ${ordem.produtos.fold(0.0, (previousValue, element) => previousValue + element.qtde).toKg()}',
                            style: AppCss.minimumRegular
                                .setSize(11)
                                .setColor(AppColors.black),
                          ),
                          Text(
                            'Criada ${ordem.createdAt.textHour()}',
                            style: AppCss.minimumRegular
                                .setSize(11)
                                .setColor(AppColors.neutralMedium),
                          ),
                        ],
                      ),
                    ),
                    const W(8),
                    _progressChartWidget(PedidoProdutoStatus.aguardandoProducao,
                        ordem.getPrcntgAguardando()),
                    const W(16),
                    _progressChartWidget(PedidoProdutoStatus.produzindo,
                        ordem.getPrcntgProduzindo()),
                    const W(16),
                    _progressChartWidget(
                        PedidoProdutoStatus.pronto, ordem.getPrcntgPronto()),
                    const W(16),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: AppColors.neutralMedium,
                    ),
                  ],
                ),
              ),
            ),
            if (!ordem.freezed.isFreezed)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primaryMain.withOpacity(0.5),
                  borderRadius:
                      const BorderRadius.only(bottomRight: Radius.circular(8)),
                ),
                child: Text(
                  ordem.beltIndex != null ? '${ordem.beltIndex! + 1}º' : '-',
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[900]!,
                      fontWeight: FontWeight.bold),
                ),
              )
          ],
        ),
      ),
    );
  }

  Widget _progressChartWidget(PedidoProdutoStatus status, double porcentagem) {
    return Stack(
      alignment: Alignment.center,
      children: [
        CircularProgressIndicator(
          value: porcentagem,
          backgroundColor: status.color.withOpacity(0.2),
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation(status.color),
        ),
        Text(
          '${(porcentagem * 100).percent}%',
          style: AppCss.minimumBold.setSize(10),
        )
      ],
    );
  }
}
