import 'package:flutter/material.dart';

enum MateriaPrimaStatus { disponivel }

extension PedidoStatusExtension on MateriaPrimaStatus {
  String get label {
    switch (this) {
      case MateriaPrimaStatus.disponivel:
        return 'Disponível';
    }
  }

  Color get color {
    switch (this) {
      case MateriaPrimaStatus.disponivel:
        return Colors.green;
    }
  }

  IconData get icon {
    switch (this) {
      case MateriaPrimaStatus.disponivel:
        return Icons.check;
    }
  }
}
