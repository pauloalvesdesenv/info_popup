import 'package:aco_plus/app/core/client/firestore/collections/automatizacao/models/automatizacao_model.dart';
import 'package:aco_plus/app/core/extensions/string_ext.dart';
import 'package:aco_plus/app/core/models/app_stream.dart';

final automatizacaoCtrl = AutomatizacaoController();
AutomatizacaoModel get automatizacao => automatizacaoCtrl.automatizacao!;

class AutomatizacaoController {
  static final AutomatizacaoController _instance = AutomatizacaoController._();

  AutomatizacaoController._();

  factory AutomatizacaoController() => _instance;

  final AppStream<AutomatizacaoModel?> automatizacaoStream =
      AppStream<AutomatizacaoModel?>.seed(null);
  AutomatizacaoModel? get automatizacao => automatizacaoStream.value;

  void onInit() {
    // utilsStream.add(AutomatizacaoUtils());
    // FirestoreClient.automatizacaos.fetch();
  }

  // final AppStream<AutomatizacaoCreateModel> formStream = AppStream<AutomatizacaoCreateModel>();
  // AutomatizacaoCreateModel get form => formStream.value;

  void init(AutomatizacaoModel? automatizacao) {
    // formStream.add(automatizacao != null
    //     ? AutomatizacaoCreateModel.edit(automatizacao)
    //     : AutomatizacaoCreateModel());
  }

  List<AutomatizacaoModel> getAutomatizacaoesFiltered(
      String search, List<AutomatizacaoModel> automatizacaos) {
    if (search.length < 3) return automatizacaos;
    List<AutomatizacaoModel> filtered = [];
    for (final automatizacao in automatizacaos) {
      if (automatizacao.toString().toCompare.contains(search.toCompare)) {
        filtered.add(automatizacao);
      }
    }
    return filtered;
  }

  Future<void> onConfirm(_, AutomatizacaoModel? automatizacao) async {
    // try {
    //   onValid();
    //   final newAutomatizacao = form.toAutomatizacaoModel(automatizacao);
    //   if (form.isEdit) {
    //     await FirestoreClient.automatizacaos.update(newAutomatizacao);
    //   } else {
    //     await FirestoreClient.automatizacaos.add(newAutomatizacao);
    //   }
    //   if (newAutomatizacao.isDefault) {
    //     await FirestoreClient.automatizacaos.setDefault(newAutomatizacao.id);
    //   }
    //   pop(_);
    //   NotificationService.showPositive(
    //       'Automatizacao ${form.isEdit ? 'Editado' : 'Adicionado'}',
    //       'Operação realizada com sucesso',
    //       position: NotificationPosition.bottom);
    //   await FirestoreClient.automatizacaos.fetch();
    // } catch (e) {
    //   NotificationService.showNegative('Erro', e.toString(),
    //       position: NotificationPosition.bottom);
    // }
  }

  Future<void> onDelete(_, AutomatizacaoModel automatizacao) async {
    // if (await _isDeleteUnavailable(automatizacao)) return;
    // await FirestoreClient.automatizacaos.delete(automatizacao);
    // pop(_);
    // NotificationService.showPositive(
    //     'Automatizacao Excluido', 'Operação realizada com sucesso',
    //     position: NotificationPosition.bottom);
    // await FirestoreClient.automatizacaos.fetch();
  }

  void onValid() {
    // if (form.name.text.isEmpty) {
    //   throw Exception('Nome não pode ser vazio');
    // }
  }
}
