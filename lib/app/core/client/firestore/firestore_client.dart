import 'package:aco_plus/app/core/client/firestore/collections/usuario/usuario_collection.dart';

class FirestoreClient {
  static UsuarioCollection usuarios = UsuarioCollection();

  static init() async {
    await usuarios.start();
    await usuarios.listen();
  }
}
