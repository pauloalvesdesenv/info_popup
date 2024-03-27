import 'package:aco_plus/app/core/client/firestore/collections/cliente/cliente_model.dart';
import 'package:aco_plus/app/core/client/firestore/firestore_client.dart';
import 'package:aco_plus/app/core/extensions/string_ext.dart';
import 'package:aco_plus/app/core/models/app_stream.dart';
import 'package:aco_plus/app/core/services/notification_service.dart';
import 'package:aco_plus/app/core/utils/global_resource.dart';
import 'package:aco_plus/app/modules/cliente/cliente_view_model.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

final clienteCtrl = ClienteController();
ClienteModel get cliente => clienteCtrl.cliente!;

class ClienteController {
  static final ClienteController _instance = ClienteController._();

  ClienteController._();

  factory ClienteController() => _instance;

  final AppStream<ClienteModel?> clienteStream = AppStream<ClienteModel?>.seed(null);
  ClienteModel? get cliente => clienteStream.value;

  final AppStream<ClienteUtils> utilsStream = AppStream<ClienteUtils>.seed(ClienteUtils());
  ClienteUtils get utils => utilsStream.value;

  final AppStream<ClienteCreateModel> formStream = AppStream<ClienteCreateModel>();
  ClienteCreateModel get form => formStream.value;

  void init(ClienteModel? cliente) {
    formStream.add(cliente != null ? ClienteCreateModel.edit(cliente) : ClienteCreateModel());
  }

  List<ClienteModel> getClienteesFiltered(String search, List<ClienteModel> clientes) {
    if (search.length < 3) return clientes;
    List<ClienteModel> filtered = [];
    for (final cliente in clientes) {
      if (cliente.toString().toCompare.contains(search.toCompare)) {
        filtered.add(cliente);
      }
    }
    return filtered;
  }

  Future<void> onConfirm(_, ClienteModel? cliente, bool isFromOrder) async {
    try {
      onValid();
      if (form.isEdit) {
        final edit = form.toClienteModel();
        await FirestoreClient.clientes.update(edit);
      } else {
        await FirestoreClient.clientes.add(form.toClienteModel());
      }
      if (isFromOrder) {
        Navigator.pop(_, form.isEdit ? cliente : null);
      } else {
        pop(_);
      }
      NotificationService.showPositive(
          'Cliente ${form.isEdit ? 'Editada' : 'Adicionada'}', 'Operação realizada com sucesso',
          position: NotificationPosition.bottom);
    } catch (e) {
      NotificationService.showNegative('Erro', e.toString(), position: NotificationPosition.bottom);
    }
  }

  Future<void> onDelete(_, ClienteModel cliente) async {
    await FirestoreClient.clientes.delete(cliente);
    pop(_);
    NotificationService.showPositive('Cliente Excluida', 'Operação realizada com sucesso',
        position: NotificationPosition.bottom);
  }

  void onValid() {
    if (form.nome.text.length < 2) {
      throw Exception('Nome deve conter no mínimo 3 caracteres');
    }
    if (form.telefone.text.length < 15) {
      throw Exception('Telefone inválido');
    }
    if (form.cpf.text.length < 14) {
      throw Exception('CPF inválido');
    }
    if (form.endereco == null) {
      throw Exception('Selecione o endereço do cliente');
    }
  }
}
