// import 'package:flutter/material.dart';
// import 'package:aco_plus/app/core/client/firestore/collections/usuario/usuario_model.dart';
// import 'package:aco_plus/app/core/components/app_drop_down.dart';
// import 'package:aco_plus/app/core/components/app_drop_down_list.dart';
// import 'package:aco_plus/app/core/components/app_field.dart';
// import 'package:aco_plus/app/core/components/app_scaffold.dart';
// import 'package:aco_plus/app/core/components/done_button.dart';
// import 'package:aco_plus/app/core/components/h.dart';
// import 'package:aco_plus/app/core/components/stream_out.dart';
// import 'package:aco_plus/app/core/enums/country_states.dart';
// import 'package:aco_plus/app/core/enums/usuario_role.dart';
// import 'package:aco_plus/app/core/enums/usuario_status.dart';
// import 'package:aco_plus/app/core/utils/app_colors.dart';
// import 'package:aco_plus/app/core/utils/app_css.dart';
// import 'package:aco_plus/app/core/utils/global_resource.dart';
// import 'package:aco_plus/app/modules/usuario/usuario_controller.dart';
// import 'package:aco_plus/app/modules/usuario/usuario_view_model.dart';

// class UsuarioCreatePage extends StatefulWidget {
//   final UsuarioModel? usuario;
//   const UsuarioCreatePage({this.usuario, super.key});

//   @override
//   State<UsuarioCreatePage> createState() => _UsuarioCreatePageState();
// }

// class _UsuarioCreatePageState extends State<UsuarioCreatePage> {
//   @override
//   void initState() {
//     usuarioCtrl.init(widget.usuario);
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AppScaffold(
//         resizeAvoid: true,
//         appBar: AppBar(
//           leading: IconButton(
//               onPressed: () => pop(context),
//               icon: Icon(
//                 Icons.arrow_back,
//                 color: AppColors.white,
//               )),
//           title: Text(
//               '${usuarioCtrl.form.isEdit ? 'Editar' : 'Adicionar'} Usuario',
//               style: AppCss.largeBold.setColor(AppColors.white)),
//           actions: [
//             IconLoadingButton(() async =>
//                 await usuarioCtrl.onConfirm(context, widget.usuario))
//           ],
//           backgroundColor: AppColors.primaryMain,
//         ),
//         body: StreamOut(
//             stream: usuarioCtrl.formStream.listen,
//             child: (_, form) => body(form)));
//   }

//   Widget body(UsuarioCreateModel form) {
//     return ListView(
//       padding: const EdgeInsets.all(16),
//       children: [
//         AppField(
//           label: 'Nome Completo',
//           controller: form.nome,
//           onChanged: (_) => usuarioCtrl.formStream.update(),
//         ),
//         const H(16),
//         AppField(
//           label: 'E-mail',
//           controller: form.email,
//           onChanged: (_) => usuarioCtrl.formStream.update(),
//         ),
//         const H(16),
//         AppField(
//           label: 'Telefone',
//           controller: form.telefone,
//           onChanged: (_) => usuarioCtrl.formStream.update(),
//         ),
//         const H(16),
//         AppDropDown<UsuarioRole?>(
//           label: 'Tipo',
//           item: form.role,
//           itens: UsuarioRole.values.sublist(1),
//           itemLabel: (e) => e!.label,
//           onSelect: (e) {
//             form.role = e;
//             usuarioCtrl.formStream.update();
//           },
//         ),
//         const H(16),
//         AppDropDown<UsuarioStatus?>(
//           label: 'Status',
//           item: form.status,
//           itens: UsuarioStatus.values,
//           itemLabel: (e) => e!.label,
//           onSelect: (e) {
//             form.status = e;
//             usuarioCtrl.formStream.update();
//           },
//         ),
//         const H(16),
//         AppField(
//           label: 'Cargo/Função',
//           controller: form.funcao,
//           onChanged: (_) => usuarioCtrl.formStream.update(),
//         ),
//         const H(16),
//         AppDropDownList<CountryState>(
//           label: 'Estados',
//           itens: CountryState.values,
//           addeds: form.estados,
//           itemLabel: (e) => e.label,
//           onChanged: () {
//             usuarioCtrl.formStream.update();
//           },
//         ),
//         const H(16),
//         AppField(
//           label: 'Senha',
//           controller: form.senha,
//           onChanged: (_) => usuarioCtrl.formStream.update(),
//         ),
//         const H(24),
//         if (form.isEdit)
//           TextButton.icon(
//               style: ButtonStyle(
//                 fixedSize: const MaterialStatePropertyAll(
//                     Size.fromWidth(double.maxFinite)),
//                 foregroundColor: MaterialStatePropertyAll(AppColors.error),
//                 backgroundColor: MaterialStatePropertyAll(AppColors.white),
//                 shape: MaterialStatePropertyAll(RoundedRectangleBorder(
//                     borderRadius: AppCss.radius8,
//                     side: BorderSide(color: AppColors.error))),
//               ),
//               onPressed: () => usuarioCtrl.onDelete(context, widget.usuario!),
//               label: const Text('Excluir'),
//               icon: const Icon(
//                 Icons.delete_outline,
//               )),
//       ],
//     );
//   }
// }
