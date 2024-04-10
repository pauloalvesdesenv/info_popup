import 'package:aco_plus/app/core/client/firestore/collections/cliente/cliente_model.dart';
import 'package:aco_plus/app/core/models/endereco_model.dart';
import 'package:aco_plus/app/core/models/text_controller.dart';
import 'package:aco_plus/app/core/services/hash_service.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';

class ClienteUtils {
  final TextController search = TextController();
}

class ClienteCreateModel {
  final String id;
  TextController nome = TextController();
  TextController telefone = TextController.phone();
  TextController cpf = TextController.cpf();
  EnderecoModel? endereco;
  List<ObraModel> obras = [];
  late bool isEdit;

  ClienteCreateModel()
      : id = HashService.get,
        isEdit = false;

  ClienteCreateModel.edit(ClienteModel cliente)
      : id = cliente.id,
        isEdit = true {
    nome.text = cliente.nome;
    telefone.text = cliente.telefone;
    cpf.text = cliente.cpf;
    endereco = cliente.endereco;
    obras = cliente.obras;
  }

  ClienteModel toClienteModel() => ClienteModel(
        id: id,
        nome: nome.text,
        telefone: telefone.text,
        cpf: cpf.text,
        endereco: endereco ?? EnderecoModel.empty(),
        obras: obras,
      );
}
