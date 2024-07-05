enum SortStepType {
  createdAtDesc,
  createdAtAsc,
  localizador,
  deliveryAt,
}

extension SortStepTypeExt on SortStepType {
  String get label {
    switch (this) {
      case SortStepType.createdAtDesc:
        return 'Data de criação (mais recente primeiro)';
      case SortStepType.createdAtAsc:
        return 'Data de criação (mais antigo primeiro)';
      case SortStepType.localizador:
        return 'Nome do cartão (em ordem alfabética)';
      case SortStepType.deliveryAt:
        return 'Data de entrega';
    }
  }
}
