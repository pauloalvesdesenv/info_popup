import 'package:aco_plus/app/core/client/firestore/collections/ordem/models/ordem_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_model.dart';
import 'package:flutter/material.dart';

enum RelatorioOrdemStatus {
  AGUARDANDO_PRODUCAO,
  EM_PRODUCAO,
  PRODUZIDAS,
}

extension RelatorioOrdemStatusExt on RelatorioOrdemStatus {
  String get label {
    switch (this) {
      case RelatorioOrdemStatus.AGUARDANDO_PRODUCAO:
        return 'Aguardando Produção';
      case RelatorioOrdemStatus.EM_PRODUCAO:
        return 'Em Produção';
      case RelatorioOrdemStatus.PRODUZIDAS:
        return 'Produzidas';
    }
  }

}

class RelatorioOrdemViewModel {
  RelatorioOrdemStatus? status;
  DateTimeRange? dates;
  RelatorioOrdemModel? relatorio;
}

class RelatorioOrdemModel {
  final RelatorioOrdemStatus status;
  final List<OrdemModel> ordens;
  final DateTimeRange? dates;
  final DateTime createdAt = DateTime.now();

  RelatorioOrdemModel(this.status, this.ordens, {this.dates});
}
