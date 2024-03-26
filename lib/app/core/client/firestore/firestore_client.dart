import 'package:programacao/app/core/client/firestore/collections/fornecedor/fornecedor_collection.dart';
import 'package:programacao/app/core/client/firestore/collections/ordem/ordem_collection.dart';
import 'package:programacao/app/core/client/firestore/collections/transportadora/transportadora_collection.dart';
import 'package:programacao/app/core/client/firestore/collections/usuario/usuario_collection.dart';

import 'collections/motorista/motorista_collection.dart';

class FirestoreClient {
  static UsuarioCollection usuarios = UsuarioCollection();
  static TransportadoraCollection transportadoras = TransportadoraCollection();
  static OrdemCollection ordens = OrdemCollection();
  static FornecedorCollection fornecedores = FornecedorCollection();
  static MotoristaCollection motoristas = MotoristaCollection();

  static init() async {
    await usuarios.start();
    await usuarios.listen();
    await transportadoras.start();
    await transportadoras.listen();
    await ordens.start();
    await ordens.listen();
    await fornecedores.start();
    await fornecedores.listen();
    await motoristas.start();
    await motoristas.listen();
  }
}
