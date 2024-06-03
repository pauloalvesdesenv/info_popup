import 'package:aco_plus/app/core/client/firestore/collections/step/models/step_model.dart';
import 'package:aco_plus/app/core/client/firestore/firestore_client.dart';
import 'package:aco_plus/app/core/components/app_drawer.dart';
import 'package:aco_plus/app/core/components/app_field.dart';
import 'package:aco_plus/app/core/components/app_scaffold.dart';
import 'package:aco_plus/app/core/components/divisor.dart';
import 'package:aco_plus/app/core/components/empty_data.dart';
import 'package:aco_plus/app/core/components/stream_out.dart';
import 'package:aco_plus/app/core/components/w.dart';
import 'package:aco_plus/app/core/extensions/date_ext.dart';
import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:aco_plus/app/core/utils/global_resource.dart';
import 'package:aco_plus/app/modules/base/base_controller.dart';
import 'package:aco_plus/app/modules/step/step_controller.dart';
import 'package:aco_plus/app/modules/step/step_view_model.dart';
import 'package:aco_plus/app/modules/step/ui/step_create_page.dart';
import 'package:flutter/material.dart';

class StepsPage extends StatefulWidget {
  const StepsPage({super.key});

  @override
  State<StepsPage> createState() => _StepsPageState();
}

class _StepsPageState extends State<StepsPage> {
  @override
  void initState() {
    FirestoreClient.steps.fetch();
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
            Text('Etapas', style: AppCss.largeBold.setColor(AppColors.white)),
        actions: [
          IconButton(
              onPressed: () => push(context, const StepCreatePage()),
              icon: Icon(
                Icons.add,
                color: AppColors.white,
              ))
        ],
        backgroundColor: AppColors.primaryMain,
      ),
      body: StreamOut<List<StepModel>>(
        stream: FirestoreClient.steps.dataStream.listen,
        builder: (_, __) => StreamOut<StepUtils>(
          stream: stepCtrl.utilsStream.listen,
          builder: (_, utils) {
            final steps =
                stepCtrl.getStepesFiltered(utils.search.text, __).toList();
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: AppField(
                    hint: 'Pesquisar',
                    controller: utils.search,
                    suffixIcon: Icons.search,
                    onChanged: (_) => stepCtrl.utilsStream.update(),
                  ),
                ),
                Expanded(
                  child: steps.isEmpty
                      ? const EmptyData()
                      : RefreshIndicator(
                          onRefresh: () async => FirestoreClient.steps.fetch(),
                          child: ListView.separated(
                            itemCount: steps.length,
                            separatorBuilder: (_, i) => const Divisor(),
                            itemBuilder: (_, i) => _itemStepWidget(steps[i]),
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

  ListTile _itemStepWidget(StepModel step) {
    return ListTile(
      onTap: () => push(StepCreatePage(step: step)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      title: Text(
        step.name,
        style: AppCss.mediumBold,
      ),
      subtitle: Text(
        'Criado em ${step.createdAt.textHour()}',
        style: AppCss.minimumRegular,
      ),
      trailing: SizedBox(
        width: 50,
        child: Row(
          children: [
            Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                color: step.color,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: AppColors.neutralMedium),
              ),
            ),
            const W(8),
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
}
