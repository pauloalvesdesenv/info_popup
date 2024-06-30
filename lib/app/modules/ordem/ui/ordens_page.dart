import 'package:aco_plus/app/core/client/firestore/collections/ordem/models/ordem_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_produto_status_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/usuario/enums/user_permission_type.dart';
import 'package:aco_plus/app/core/client/firestore/firestore_client.dart';
import 'package:aco_plus/app/core/components/app_drawer.dart';
import 'package:aco_plus/app/core/components/app_drop_down_list.dart';
import 'package:aco_plus/app/core/components/app_field.dart';
import 'package:aco_plus/app/core/components/app_scaffold.dart';
import 'package:aco_plus/app/core/components/divisor.dart';
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
            List<OrdemModel> ordens =
                ordemCtrl.getOrdensFiltered(utils.search.text, __).toList();
            ordens.sort((a, b) => b.createdAt.compareTo(a.createdAt));
            if (utils.status.isNotEmpty) {
              ordens =
                  ordens.where((e) => utils.status.contains(e.status)).toList();
            }
            return RefreshIndicator(
              onRefresh: () async => FirestoreClient.ordens.fetch(),
              child: ListView(
                children: [
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
                        AppDropDownList<PedidoProdutoStatus>(
                          label: 'Ordernar por',
                          addeds: utils.status,
                          itens: const [
                            PedidoProdutoStatus.aguardandoProducao,
                            PedidoProdutoStatus.produzindo,
                            PedidoProdutoStatus.pronto
                          ],
                          itemLabel: (e) => e.label,
                          itemColor: (e) => e.color,
                          onChanged: () {
                            ordemCtrl.utilsStream.update();
                          },
                        )
                      ],
                    ),
                  ),
                  ordens.isEmpty
                      ? const EmptyData()
                      : ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: ordens.length,
                          separatorBuilder: (_, i) => const Divisor(),
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
      onTap: () => push(OrdemPage(ordem)),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
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
                    'Criada dia ${ordem.createdAt.text()}',
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
            _progressChartWidget(
                PedidoProdutoStatus.produzindo, ordem.getPrcntgProduzindo()),
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
