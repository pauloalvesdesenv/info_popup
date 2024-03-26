import 'dart:convert';

import 'package:programacao/app/core/client/firestore/collections/transportadora/transportadora_model.dart';
import 'package:programacao/app/core/client/firestore/collections/usuario/usuario_model.dart';
import 'package:programacao/app/core/client/firestore/models/usuario_main_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppRepository {
  static Future<bool> add(UsuarioMainModel usuario) async {
    final sharedPrefs = await SharedPreferences.getInstance();
    sharedPrefs.setString('usuarios', usuario.toJson());
    return true;
  }

  static Future<UsuarioMainModel?> get() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    final usuarios = sharedPrefs.getString('usuarios');
    if (usuarios == null) return null;
    final map = jsonDecode(usuarios);
    return map['role'] == 7
        ? TransportadoraModel.fromMap(map)
        : UsuarioModel.fromMap(map);
  }

  static Future<void> clear() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    sharedPrefs.clear();
  }
}
