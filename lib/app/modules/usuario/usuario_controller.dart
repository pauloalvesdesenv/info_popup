import 'package:aco_plus/app/app_repository.dart';
import 'package:aco_plus/app/core/client/firestore/collections/usuario/usuario_model.dart';
import 'package:aco_plus/app/core/models/app_stream.dart';

final usuarioCtrl = UsuarioController();
UsuarioModel get usuario => usuarioCtrl.usuario!;

class UsuarioController {
  static final UsuarioController _instance = UsuarioController._();

  UsuarioController._();

  factory UsuarioController() => _instance;

  final AppStream<UsuarioModel?> usuarioStream = AppStream<UsuarioModel?>.seed(null);
  UsuarioModel? get usuario => usuarioStream.value;

  // final AppStream<UsuarioUtils> utilsStream =
  //     AppStream<UsuarioUtils>.seed(UsuarioUtils());
  // UsuarioUtils get utils => utilsStream.value;

  // final AppStream<UsuarioCreateModel> formStream =
  //     AppStream<UsuarioCreateModel>();
  // UsuarioCreateModel get form => formStream.value;

  // void init(UsuarioModel? usuario) {
  //   formStream.add(usuario != null
  //       ? UsuarioCreateModel.edit(usuario)
  //       : UsuarioCreateModel());
  // }

  // List<UsuarioModel> getUsuariosFiltered(
  //     String search, List<UsuarioModel> usuarios) {
  //   if (search.length < 3) return usuarios;
  //   List<UsuarioModel> filtered = [];
  //   for (final usuario in usuarios) {
  //     if (usuario.toString().toCompare.contains(search.toCompare)) {
  //       filtered.add(usuario);
  //     }
  //   }
  //   return filtered;
  // }

  // Future<void> onConfirm(_, UsuarioModel? usuario) async {
  //   try {
  //     onValid();
  //     if (form.isEdit) {
  //       final edit = form.toUsuarioModel();
  //       await FirestoreClient.usuarios.update(edit);
  //     } else {
  //       await FirestoreClient.usuarios.add(form.toUsuarioModel());
  //     }
  //     pop(_);
  //     NotificationService.showPositive(
  //         'Usuário ${form.isEdit ? 'Editado' : 'Adicionado'}',
  //         'Operação realizada com sucesso',
  //         position: NotificationPosition.bottom);
  //   } catch (e) {
  //     NotificationService.showNegative(
  //         'Erro ao realizar operação', e.toString(),
  //         position: NotificationPosition.bottom);
  //   }
  // }

  // Future<void> onDelete(_, UsuarioModel usuario) async {
  //   await FirestoreClient.usuarios.delete(usuario);
  //   pop(_);
  //   NotificationService.showPositive(
  //       'Usuario Excluida', 'Operação realizada com sucesso',
  //       position: NotificationPosition.bottom);
  // }

  // void onValid() {
  //   if (form.nome.text.length < 2) {
  //     throw Exception('Nome deve conter no mínimo 3 caracteres');
  //   }
  //   if (!isEmail(form.email.text)) {
  //     throw Exception('E-mail inválido');
  //   }
  //   if (form.telefone.text.length < 14) {
  //     throw Exception('Telefone inválido');
  //   }
  //   if (form.status == null) {
  //     throw Exception('Defina o status do usuário');
  //   }
  //   if (form.funcao.text.isEmpty) {
  //     throw Exception('Defina o cargo/função do usuário');
  //   }
  //   if (form.estados.isEmpty) {
  //     throw Exception('Selecione no mínimo um estado');
  //   }
  //   if (form.senha.text.length < 6) {
  //     throw Exception('Senha deve conter no mínimo 6 caracteres');
  //   }
  // }

  Future<void> getCurrentUser() async {
    UsuarioModel? user = await AppRepository.get();
    usuarioStream.add(user);
  }

  Future<void> setCurrentUser(UsuarioModel usuario) async {
    await AppRepository.add(usuario);
    await getCurrentUser();
  }

  Future<void> clearCurrentUser() async {
    await AppRepository.clear();
    getCurrentUser();
  }
}
