// import 'package:flutter/material.dart';
// import 'package:flutter_masked_text2/flutter_masked_text2.dart';
// import 'package:aco_plus/app/core/client/firestore/collections/usuario/usuario_model.dart';
// import 'package:aco_plus/app/core/enums/country_states.dart';
// import 'package:aco_plus/app/core/enums/usuario_role.dart';
// import 'package:aco_plus/app/core/enums/usuario_status.dart';
// import 'package:aco_plus/app/core/models/text_controller.dart';


// class UsuarioUtils {
//   final TextController search = TextController();
//   UsuarioStatus? status;
// }

// class UsuarioCreateModel {
//   final String id;
//   TextController nome = TextController();
//   TextController email = TextController();
//   TextController telefone =
//       MaskedTextController(mask: '(00) 00000-0000');
//   TextController funcao = TextController();
//   List<CountryState> estados = [];
//   UsuarioRole? role;
//   UsuarioStatus? status;
//   late bool isEdit;
//   TextController senha = TextController();

//   UsuarioCreateModel()
//       : id = HashService.get,
//         isEdit = false;

//   UsuarioCreateModel.edit(UsuarioModel user)
//       : id = user.id,
//         isEdit = true {
//     nome.text = user.nome;
//     email.text = user.email;
//     telefone.text = user.telefone;
//     funcao.text = user.funcao;
//     estados = user.estados;
//     role = user.role;
//     status = user.status;
//     senha.text = user.senha;
//   }

//   UsuarioModel toUsuarioModel() => UsuarioModel(
//         id: id,
//         nome: nome.text,
//         email: email.text,
//         telefone: telefone.text,
//         role: role!,
//         funcao: funcao.text,
//         estados: estados,
//         status: status!,
//         senha: senha.text,
//       );
// }
