enum SortType { alfabetic, date }

extension SortTypeExt on SortType {
  String get name {
    switch (this) {
      case SortType.alfabetic:
        return 'Alfabética';
      case SortType.date:
        return 'Data Entrega';
    }
  }
}

enum SortOrder { asc, desc }

extension SortOrderExt on SortOrder {
  String get name {
    switch (this) {
      case SortOrder.asc:
        return 'Crescente';
      case SortOrder.desc:
        return 'Decrescente';
    }
  }
}
