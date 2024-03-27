import 'package:aco_plus/app/core/client/firestore/collections/ordem/models/ordem_model.dart';
import 'package:aco_plus/app/core/client/firestore/firestore_client.dart';
import 'package:aco_plus/app/core/components/app_drawer.dart';
import 'package:aco_plus/app/core/components/app_field.dart';
import 'package:aco_plus/app/core/components/app_scaffold.dart';
import 'package:aco_plus/app/core/components/divisor.dart';
import 'package:aco_plus/app/core/components/empty_data.dart';
import 'package:aco_plus/app/core/components/stream_out.dart';
import 'package:aco_plus/app/core/extensions/date_ext.dart';
import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:aco_plus/app/core/utils/global_resource.dart';
import 'package:aco_plus/app/modules/base/base_controller.dart';
import 'package:aco_plus/app/modules/ordem/ordem_controller.dart';
import 'package:aco_plus/app/modules/ordem/ui/ordem_create_page.dart';
import 'package:aco_plus/app/modules/ordem/ui/ordem_page.dart';
import 'package:aco_plus/app/modules/ordem/view_models/ordem_view_model.dart';
import 'package:flutter/material.dart';

class OrdensPage extends StatefulWidget {
  const OrdensPage({super.key});

  @override
  State<OrdensPage> createState() => _OrdensPageState();
}

class _OrdensPageState extends State<OrdensPage> {
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
        title: Text('Ordens', style: AppCss.largeBold.setColor(AppColors.white)),
        actions: [
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
        child: (_, __) => StreamOut<OrdemUtils>(
          stream: ordemCtrl.utilsStream.listen,
          child: (_, utils) {
            final ordens = ordemCtrl.getOrdemesFiltered(utils.search.text, __).toList();
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: AppField(
                    hint: 'Pesquisar',
                    controller: utils.search,
                    suffixIcon: Icons.search,
                    onChanged: (_) => ordemCtrl.utilsStream.update(),
                  ),
                ),
                Expanded(
                  child: ordens.isEmpty
                      ? const EmptyData()
                      : ListView.separated(
                          itemCount: ordens.length,
                          separatorBuilder: (_, i) => const Divisor(),
                          itemBuilder: (_, i) => _itemOrdemWidget(ordens[i]),
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  ListTile _itemOrdemWidget(OrdemModel ordem) {
    return ListTile(
      onTap: () => push(OrdemPage(ordem)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      title: Text(
        'Ordem ${ordem.id}',
        style: AppCss.mediumBold,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${ordem.produto.nome} ${ordem.produto.descricao} - ${ordem.produtos.map((e) => e.qtde)}Kg',
            style: AppCss.minimumRegular.setSize(11).setColor(AppColors.black),
          ),
          Text(
            'Criada dia ${ordem.createdAt.text()}',
            style: AppCss.minimumRegular.setSize(11).setColor(AppColors.neutralMedium),
          ),
        ],
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 14,
        color: AppColors.neutralMedium,
      ),
    );
  }
}
