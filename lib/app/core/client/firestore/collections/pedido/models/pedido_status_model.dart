import 'dart:convert';

import 'package:aco_plus/app/core/client/firestore/collections/pedido/enums/pedido_status.dart';

class PedidoStatusModel {
  final PedidoStatus status;
  final DateTime createdAt;
  PedidoStatusModel({
    required this.status,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'status': status.index,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory PedidoStatusModel.fromMap(Map<String, dynamic> map) {
    return PedidoStatusModel(
      status: PedidoStatus.values[map['status']],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
    );
  }

  String toJson() => json.encode(toMap());

  factory PedidoStatusModel.fromJson(String source) =>
      PedidoStatusModel.fromMap(json.decode(source));
}
