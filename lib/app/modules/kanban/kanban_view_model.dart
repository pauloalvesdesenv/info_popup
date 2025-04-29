import 'dart:async';

import 'package:aco_plus/app/core/client/firestore/collections/cliente/cliente_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/step/models/step_model.dart';
import 'package:aco_plus/app/core/extensions/string_ext.dart';
import 'package:aco_plus/app/core/models/text_controller.dart';
import 'package:flutter/material.dart';
import 'package:info_popup/info_popup.dart';
import 'package:table_calendar/table_calendar.dart';

enum KanbanViewMode { calendar, kanban }

class KanbanUtils {
  KanbanViewMode view = KanbanViewMode.kanban;
  CalendarFormat calendarFormat = CalendarFormat.month;
  Map<StepModel, List<PedidoModel>> kanban;
  Map<String, List<PedidoModel>> calendar;
  Map<DateTime, List<PedidoModel>>? day;
  final ScrollController scroll = ScrollController();
  PedidoModel? pedido;
  bool get isPedidoSelected => pedido != null;
  bool get isDaySelected => day != null;
  TextController search = TextController();
  ClienteModel? cliente;
  TextController clienteEC = TextController();
  Timer? timer;
  late InfoPopupController controller;

  void cancelTimer() {
    if (timer?.isActive ?? false) {
      timer?.cancel();
      timer = null;
    }
  }

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
      if (pedido.filtro.toCompare.contains(search.text.toCompare)) {
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
