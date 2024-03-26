// import 'package:flutter/material.dart';
// import 'package:aco_plus/app/core/client/firestore/collections/usuario/usuario_model.dart';
// import 'package:aco_plus/app/core/client/firestore/firestore_client.dart';
// import 'package:aco_plus/app/core/components/app_drawer.dart';
// import 'package:aco_plus/app/core/components/app_field.dart';
// import 'package:aco_plus/app/core/components/app_scaffold.dart';
// import 'package:aco_plus/app/core/components/divisor.dart';
// import 'package:aco_plus/app/core/components/empty_data.dart';
// import 'package:aco_plus/app/core/components/stream_out.dart';
// import 'package:aco_plus/app/core/components/type_selector_widget.dart';
// import 'package:aco_plus/app/core/components/w.dart';
// import 'package:aco_plus/app/core/enums/usuario_role.dart';
// import 'package:aco_plus/app/core/enums/usuario_status.dart';
// import 'package:aco_plus/app/core/utils/app_colors.dart';
// import 'package:aco_plus/app/core/utils/app_css.dart';
// import 'package:aco_plus/app/core/utils/global_resource.dart';
// import 'package:aco_plus/app/modules/base/base_controller.dart';
// import 'package:aco_plus/app/modules/usuario/ui/usuario_create_page.dart';
// import 'package:aco_plus/app/modules/usuario/usuario_controller.dart';
// import 'package:aco_plus/app/modules/usuario/usuario_view_model.dart';

// class UsuariosPage extends StatefulWidget {
//   const UsuariosPage({super.key});

//   @override
//   State<UsuariosPage> createState() => _UsuariosPageState();
// }

// class _UsuariosPageState extends State<UsuariosPage> {
//   @override
//   Widget build(BuildContext context) {
//     return AppScaffold(
//       drawer: const AppDrawer(),
//       appBar: AppBar(
//         leading: IconButton(
//           onPressed: () => baseCtrl.key.currentState!.openDrawer(),
//           icon: Icon(
//             Icons.menu,
//             color: AppColors.white,
//           ),
//         ),
//         title:
//             Text('Usuarios', style: AppCss.largeBold.setColor(AppColors.white)),
//         actions: [
//           IconButton(
//               onPressed: () => push(context, const UsuarioCreatePage()),
//               icon: Icon(
//                 Icons.add,
//                 color: AppColors.white,
//               ))
//         ],
//         backgroundColor: AppColors.primaryMain,
//       ),
//       body: StreamOut<List<UsuarioModel>>(
//         stream: FirestoreClient.usuarios.dataStream.listen,
//         child: (_, __) => StreamOut<UsuarioUtils>(
//           stream: usuarioCtrl.utilsStream.listen,
//           child: (_, utils) {
//             final usuarios = usuarioCtrl
//                 .getUsuariosFiltered(utils.search.text, __)
//                 .where((e) => ![
//                       UsuarioRole.proprietario,
//                       UsuarioRole.transportadora
//                     ].contains(e.role))
//                 .toList();
//             if (utils.status != null) {
//               usuarios.removeWhere((e) => e.status != utils.status);
//             }
//             return Column(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(16),
//                   child: AppField(
//                     hint: 'Pesquisar',
//                     controller: utils.search,
//                     suffixIcon: Icons.search,
//                     onChanged: (_) => usuarioCtrl.utilsStream.update(),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
//                   child: Center(
//                     child: TypeSelectorWidget<UsuarioStatus?>(
//                       label: '',
//                       values: UsuarioStatus.values,
//                       value: utils.status,
//                       onChanged: (e) {
//                         if (e == utils.status) {
//                           utils.status = null;
//                         } else {
//                           utils.status = e;
//                         }
//                         usuarioCtrl.utilsStream.update();
//                       },
//                       itemLabel: (e) => e?.label ?? '',
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: usuarios.isEmpty
//                       ? const EmptyData()
//                       : ListView.separated(
//                           itemCount: usuarios.length,
//                           separatorBuilder: (_, i) => const Divisor(),
//                           itemBuilder: (_, i) =>
//                               _itemUsuarioWidget(usuarios[i]),
//                         ),
//                 ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }

//   ListTile _itemUsuarioWidget(UsuarioModel usuario) {
//     return ListTile(
//       onTap: () => push(UsuarioCreatePage(usuario: usuario)),
//       contentPadding: const EdgeInsets.symmetric(horizontal: 16),
//       title: Row(
//         children: [
//           Container(
//             width: 10,
//             height: 10,
//             decoration: BoxDecoration(
//                 shape: BoxShape.circle, color: usuario.status.color),
//           ),
//           const W(8),
//           Expanded(
//             child: Text(
//               usuario.nome,
//               style: AppCss.mediumBold,
//             ),
//           ),
//         ],
//       ),
//       subtitle: Text(
//         usuario.role.label,
//       ),
//       trailing: Icon(
//         Icons.arrow_forward_ios,
//         size: 14,
//         color: AppColors.neutralMedium,
//       ),
//     );
//   }
// }
