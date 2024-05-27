import 'package:aco_plus/app/core/client/firestore/collections/cliente/cliente_collection.dart';
import 'package:aco_plus/app/core/client/firestore/collections/ordem/ordem_collection.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/pedido_collection.dart';
import 'package:aco_plus/app/core/client/firestore/collections/produto/produto_collection.dart';
import 'package:aco_plus/app/core/client/firestore/collections/usuario/usuario_collection.dart';

class FirestoreClient {
  static UsuarioCollection usuarios = UsuarioCollection();
  static ClienteCollection clientes = ClienteCollection();
  static ProdutoCollection produtos = ProdutoCollection();
  static PedidoCollection pedidos = PedidoCollection();
  static OrdemCollection ordens = OrdemCollection();

  static init() async {
    await usuarios.start();
    await clientes.start();
    await produtos.start();
    await pedidos.start();
    await ordens.start();

    // await usuarios.listen();
    // await clientes.listen();
    // await produtos.listen();
    // await pedidos.listen();
    // await ordens.listen();
  }
}
