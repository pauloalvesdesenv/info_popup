import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_produto_status_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/produto/produto_model.dart';

enum ProdutoProduzido {
  day,
  week,
  month
}

class ProdutoProduzidoModel {
  final DateTime date;
  double qtde;
  ProdutoProduzidoModel({
    required this.date,
    required this.qtde,
  });
}
