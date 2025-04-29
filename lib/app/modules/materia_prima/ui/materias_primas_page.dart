import 'package:aco_plus/app/core/client/firestore/collections/materia_prima/models/materia_prima_model.dart';
import 'package:aco_plus/app/core/client/firestore/firestore_client.dart';
import 'package:aco_plus/app/core/components/app_drawer.dart';
import 'package:aco_plus/app/core/components/app_field.dart';
import 'package:aco_plus/app/core/components/app_scaffold.dart';
import 'package:aco_plus/app/core/components/divisor.dart';
import 'package:aco_plus/app/core/components/empty_data.dart';
import 'package:aco_plus/app/core/components/stream_out.dart';
import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:aco_plus/app/core/utils/global_resource.dart';
import 'package:aco_plus/app/modules/base/base_controller.dart';
import 'package:aco_plus/app/modules/materia_prima/materia_prima_controller.dart';
import 'package:aco_plus/app/modules/materia_prima/materia_prima_view_model.dart';
import 'package:aco_plus/app/modules/materia_prima/ui/materias_primas_create_page.dart';
import 'package:flutter/material.dart';

class MateriasPrimasPage extends StatefulWidget {
  const MateriasPrimasPage({super.key});

  @override
  State<MateriasPrimasPage> createState() => _MateriasPrimasPageState();
}

class _MateriasPrimasPageState extends State<MateriasPrimasPage> {
  @override
  void initState() {
    FirestoreClient.materiaPrimas.fetch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => baseCtrl.key.currentState!.openDrawer(),
          icon: Icon(Icons.menu, color: AppColors.white),
        ),
        title: Text(
          'Materias Primas',
          style: AppCss.largeBold.setColor(AppColors.white),
        ),
        actions: [
          IconButton(
            onPressed: () => push(context, const MateriaPrimaCreatePage()),
            icon: Icon(Icons.add, color: AppColors.white),
          ),
        ],
        backgroundColor: AppColors.primaryMain,
      ),
      body: StreamOut<List<MateriaPrimaModel>>(
        stream: FirestoreClient.materiaPrimas.dataStream.listen,
        builder:
            (_, __) => StreamOut<MateriaPrimaUtils>(
              stream: materiaPrimaCtrl.utilsStream.listen,
              builder: (_, utils) {
                final materiaPrimas =
                    materiaPrimaCtrl
                        .getMateriaPrimaesFiltered(utils.search.text, __)
                        .toList();
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: AppField(
                        hint: 'Pesquisar',
                        controller: utils.search,
                        suffixIcon: Icons.search,
                        onChanged: (_) => materiaPrimaCtrl.utilsStream.update(),
                      ),
                    ),
                    Expanded(
                      child:
                          materiaPrimas.isEmpty
                              ? const EmptyData()
                              : RefreshIndicator(
                                onRefresh:
                                    () async =>
                                        FirestoreClient.materiaPrimas.fetch(),
                                child: ListView.separated(
                                  itemCount: materiaPrimas.length,
                                  separatorBuilder: (_, i) => const Divisor(),
                                  itemBuilder:
                                      (_, i) => _itemMateriaPrimaWidget(
                                        materiaPrimas[i],
                                      ),
                                ),
                              ),
                    ),
                  ],
                );
              },
            ),
      ),
    );
  }

  ListTile _itemMateriaPrimaWidget(MateriaPrimaModel materiaPrima) {
    return ListTile(
      onTap: () => push(MateriaPrimaCreatePage(materiaPrima: materiaPrima)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      title: Text(materiaPrima.corridaLote, style: AppCss.mediumBold),
      subtitle: Text(
        '${materiaPrima.fabricanteModel.nome} - ${materiaPrima.produto.labelMinified.replaceAll(' - ', ' ')}',
        style: AppCss.mediumRegular,
      ),
      // subtitle: Column(
      //   crossAxisAlignment: CrossAxisAlignment.start,
      //   children: [
      //     Text(
      //       'Tel: ${materiaPrima.telefone} - Qtd. Obras: ${materiaPrima.obras.length}',
      //     ),
      //     Text(
      //       materiaPrima.endereco.name,
      //       style: AppCss.minimumRegular
      //           .setSize(12)
      //           .setColor(AppColors.neutralMedium),
      //     ),
      //   ],
      // ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 14,
        color: AppColors.neutralMedium,
      ),
    );
  }
}
