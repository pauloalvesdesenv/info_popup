import 'package:aco_plus/app/core/client/firestore/collections/cliente/cliente_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/step/models/step_model.dart';
import 'package:aco_plus/app/core/extensions/string_ext.dart';
import 'package:aco_plus/app/core/models/text_controller.dart';
import 'package:flutter/material.dart';

enum KanbanViewMode {
  calendar,
  kanban,
}

class KanbanUtils {
  KanbanViewMode view = KanbanViewMode.kanban;
  Map<StepModel, List<PedidoModel>> kanban;
  Map<String, List<PedidoModel>> calendar;
  final ScrollController scroll = ScrollController();
  PedidoModel? pedido;
  bool get isPedidoSelected => pedido != null;
  TextController search = TextController();
  ClienteModel? cliente;
  TextController clienteEC = TextController();

  int getFilterSteps() {
    int qtde = 0;
    if (search.text.isNotEmpty) {
      qtde++;
    }
    if (cliente != null) {
      qtde++;
    }
    return qtde;
  }

  bool hasFilter() => search.text.isNotEmpty || cliente != null;

  bool isPedidoVisibleFiltered(PedidoModel pedido) {
    if (!hasFilter()) return true;
    if (search.text.isNotEmpty) {
      if (pedido.localizador.toCompare.contains(search.text.toCompare)) {
        return true;
      }
    }
    if (cliente != null) {
      if (pedido.cliente.id == cliente!.id) return true;
    }
    return false;
  }

  KanbanUtils({required this.kanban, required this.calendar});
}
