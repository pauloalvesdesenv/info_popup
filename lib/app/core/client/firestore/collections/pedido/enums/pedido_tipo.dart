enum PedidoTipo { cd, cda }

extension PedidoTipoExtension on PedidoTipo {
  String get label {
    switch (this) {
      case PedidoTipo.cd:
        return 'Corte e Dobra';
      case PedidoTipo.cda:
        return 'Corte, Dobra e Armação';
    }
  }
}
