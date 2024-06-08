import 'package:aco_plus/app/core/client/firestore/collections/step/models/step_model.dart';
import 'package:aco_plus/app/core/client/firestore/firestore_client.dart';
import 'package:aco_plus/app/core/extensions/string_ext.dart';
import 'package:aco_plus/app/core/models/app_stream.dart';
import 'package:aco_plus/app/core/services/notification_service.dart';
import 'package:aco_plus/app/core/utils/global_resource.dart';
import 'package:aco_plus/app/modules/step/step_view_model.dart';
import 'package:overlay_support/overlay_support.dart';

final stepCtrl = StepController();
StepModel get step => stepCtrl.step!;

class StepController {
  static final StepController _instance = StepController._();

  StepController._();

  factory StepController() => _instance;

  final AppStream<StepModel?> stepStream = AppStream<StepModel?>.seed(null);
  StepModel? get step => stepStream.value;

  final AppStream<StepUtils> utilsStream =
      AppStream<StepUtils>.seed(StepUtils());
  StepUtils get utils => utilsStream.value;

  void onInit() {
    utilsStream.add(StepUtils());
    FirestoreClient.steps.fetch();
  }

  final AppStream<StepCreateModel> formStream = AppStream<StepCreateModel>();
  StepCreateModel get form => formStream.value;

  void init(StepModel? step) {
    formStream
        .add(step != null ? StepCreateModel.edit(step) : StepCreateModel());
  }

  List<StepModel> getStepesFiltered(String search, List<StepModel> steps) {
    if (search.length < 3) return steps;
    List<StepModel> filtered = [];
    for (final step in steps) {
      if (step.toString().toCompare.contains(search.toCompare)) {
        filtered.add(step);
      }
    }
    return filtered;
  }

  Future<void> onConfirm(_, StepModel? step) async {
    try {
      onValid(step);
      if (form.isEdit) {
        final edit = form.toStepModel();
        await FirestoreClient.steps.update(edit);
      } else {
        await FirestoreClient.steps.add(form.toStepModel());
      }
      pop(_);
      NotificationService.showPositive(
          'Step ${form.isEdit ? 'Editado' : 'Adicionado'}',
          'Operação realizada com sucesso',
          position: NotificationPosition.bottom);
      await FirestoreClient.steps.fetch();
    } catch (e) {
      NotificationService.showNegative('Erro', e.toString(),
          position: NotificationPosition.bottom);
    }
  }

  Future<void> onDelete(_, StepModel step) async {
    await FirestoreClient.steps.delete(step);
    pop(_);
    NotificationService.showPositive(
        'Step Excluido', 'Operação realizada com sucesso',
        position: NotificationPosition.bottom);
    await FirestoreClient.steps.fetch();
  }

  void onValid(StepModel? step) {}
}
