import 'package:aco_plus/app/core/client/firestore/collections/cliente/cliente_model.dart';
import 'package:aco_plus/app/core/enums/obra_status.dart';
import 'package:aco_plus/app/core/models/endereco_model.dart';
import 'package:aco_plus/app/core/services/hash_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';

class ClienteUtils {
  final TextEditingController search = TextEditingController();
}

class ClienteCreateModel {
  final String id;
  TextEditingController nome = TextEditingController();
  TextEditingController telefone = MaskedTextController(mask: '(00) 00000-0000');
  TextEditingController cpf = MaskedTextController(mask: '000.000.000-00');
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
        endereco: endereco!,
        obras: obras,
      );
}

class ObraCreateModel {
  final String id;
  TextEditingController descricao = TextEditingController();
  EnderecoModel? endereco;
  ClienteModel? cliente;
  ObraStatus? status;
  late bool isEdit;

  ObraCreateModel()
      : id = HashService.get,
        isEdit = false;

  ObraCreateModel.edit(ObraModel obra)
      : id = obra.id,
        isEdit = true {
    descricao.text = obra.descricao;
    endereco = obra.endereco;
    status = obra.status;
  }

  ObraModel toObraModel() => ObraModel(
        id: id,
        descricao: descricao.text,
        endereco: endereco!,
        status: status!,
      );
}
