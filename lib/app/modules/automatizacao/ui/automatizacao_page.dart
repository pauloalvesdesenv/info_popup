import 'package:aco_plus/app/core/client/firestore/collections/automatizacao/models/automatizacao_model.dart';
import 'package:aco_plus/app/core/client/firestore/firestore_client.dart';
import 'package:aco_plus/app/core/components/app_scaffold.dart';
import 'package:aco_plus/app/core/components/stream_out.dart';
import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:flutter/material.dart';

class AutomatizacaoPage extends StatefulWidget {
  const AutomatizacaoPage({super.key});

  @override
  State<AutomatizacaoPage> createState() => _AutomatizacaoPageState();
}

class _AutomatizacaoPageState extends State<AutomatizacaoPage> {
  @override
  void initState() {
    // automatizacaoCtrl.init(widget.automatizacao);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
        resizeAvoid: true,
        appBar: AppBar(
          leading: IconButton(
              onPressed: () async {},
              icon: Icon(
                Icons.arrow_back,
                color: AppColors.white,
              )),
          title: Text('Automatização de Etapas',
              style: AppCss.largeBold.setColor(AppColors.white)),
          actions: const [
            // IconLoadingButton(() async => await automatizacaoCtrl.onConfirm(
            //     context, widget.automatizacao))
          ],
          backgroundColor: AppColors.primaryMain,
        ),
        body: StreamOut(
            stream: FirestoreClient.automatizacao.dataStream.listen,
            builder: (_, automatizacao) => body(automatizacao)));
  }

  Widget body(AutomatizacaoModel automatizacao) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: automatizacao.itens
          .map((e) => const ListTile(
                title: Text('Automatização de'),
                subtitle: Text('e.subtitle'),
                trailing: Icon(Icons.arrow_forward_ios),
              ))
          .toList(),
    );
  }
}
