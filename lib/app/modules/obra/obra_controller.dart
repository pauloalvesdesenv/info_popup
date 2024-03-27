import 'package:aco_plus/app/core/client/firestore/collections/cliente/cliente_model.dart';
import 'package:aco_plus/app/core/models/app_stream.dart';
import 'package:aco_plus/app/core/services/notification_service.dart';
import 'package:aco_plus/app/modules/obra/obra_view_model.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

final obraCtrl = ObraController();
ObraModel get obra => obraCtrl.obra!;

class ObraController {
  static final ObraController _instance = ObraController._();

  ObraController._();

  factory ObraController() => _instance;

  final AppStream<ObraModel?> obraStream = AppStream<ObraModel?>.seed(null);
  ObraModel? get obra => obraStream.value;

  final AppStream<ObraUtils> utilsStream = AppStream<ObraUtils>.seed(ObraUtils());
  ObraUtils get utils => utilsStream.value;

  final AppStream<ObraCreateModel> formStream = AppStream<ObraCreateModel>();
  ObraCreateModel get form => formStream.value;

  void init(ObraModel? obra) {
    formStream.add(obra != null ? ObraCreateModel.edit(obra) : ObraCreateModel());
  }

  Future<void> onConfirm(_) async {
    try {
      onValid();
      Navigator.pop(_, formStream.value.toObraModel());
      NotificationService.showPositive(
          'Obra ${form.isEdit ? 'Editada' : 'Adicionada'}', 'Operação realizada com sucesso',
          position: NotificationPosition.bottom);
    } catch (e) {
      NotificationService.showNegative('Erro', e.toString(), position: NotificationPosition.bottom);
    }
  }

  void onValid() {
    if (form.descricao.text.length < 2) {
      throw Exception('Descrição deve conter no mínimo 3 caracteres');
    }
    if (form.status == null) {
      throw Exception('Selecione um status para a obra');
    }
    if (form.endereco == null) {
      throw Exception('Selecione um endereço para a obra');
    }
  }
}
