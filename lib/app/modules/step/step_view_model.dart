import 'package:aco_plus/app/core/client/firestore/collections/step/models/step_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/usuario/enums/usuario_role.dart';
import 'package:aco_plus/app/core/models/text_controller.dart';
import 'package:aco_plus/app/core/services/hash_service.dart';
import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class StepUtils {
  final TextController search = TextController();
}

class StepCreateModel {
  final String id;
  TextController name = TextController();
  Color color = AppColors.primaryMain;
  List<StepModel> fromSteps = [];
  List<UsuarioRole> moveRoles = [];
  DateTime createdAt = DateTime.now();

  late bool isEdit;

  StepCreateModel()
      : id = HashService.get,
        isEdit = false;

  StepCreateModel.edit(StepModel etapa)
      : id = etapa.id,
        isEdit = true {
    name.text = etapa.name;
    color = etapa.color;
    fromSteps = etapa.fromSteps;
    moveRoles = etapa.moveRoles;
    createdAt = etapa.createdAt;
  }

  StepModel toStepModel() => StepModel(
        id: id,
        name: name.text,
        color: color,
        fromStepsIds: fromSteps.map((e) => e.id).toList(),
        moveRoles: moveRoles,
        createdAt: createdAt,
      );
}
