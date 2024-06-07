import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_model.dart';
import 'package:aco_plus/app/core/models/text_controller.dart';
import 'package:flutter/material.dart';

class KanbanUtils {
  final ScrollController scroll = ScrollController();
  PedidoModel? pedido;

  bool get isPedidoSelected => pedido != null;

}
