import 'package:aco_plus/app/core/client/firestore/collections/usuario/enums/user_permission_type.dart';
import 'package:aco_plus/app/core/client/firestore/collections/usuario/enums/usuario_role.dart';
import 'package:aco_plus/app/core/components/stream_out.dart';
import 'package:aco_plus/app/core/components/w.dart';
import 'package:aco_plus/app/core/enums/app_module.dart';
import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:aco_plus/app/core/utils/global_resource.dart';
import 'package:aco_plus/app/modules/base/base_controller.dart';
import 'package:aco_plus/app/modules/config/config_page.dart';
import 'package:aco_plus/app/modules/usuario/usuario_controller.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: StreamOut<AppModule>(
        stream: baseCtrl.moduleStream.listen,
        builder: (_, module) => Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Stack(
                    alignment: Alignment.topRight,
                    children: [
                      UserAccountsDrawerHeader(
                        accountEmail: const SizedBox(),
                        currentAccountPicture: const CircleAvatar(
                          radius: 10,
                          backgroundImage: AssetImage('assets/images/logo.png'),
                        ),
                        currentAccountPictureSize: const Size(60, 60),
                        decoration: BoxDecoration(color: AppColors.primaryDark),
                        accountName: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            usuario.nome,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'v',
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 10),
                            ),
                            Text(
                              '1.0.0',
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.8)),
                            ),
                            if (usuario.role == UsuarioRole.administrador) ...[
                              const W(8),
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                  push(context, const ConfigPage());
                                },
                                child: const Icon(Icons.settings,
                                    color: Colors.white),
                              ),
                            ]
                          ],
                        ),
                      )
                    ],
                  ),
                  for (var item in AppModule.values)
                    Builder(builder: (context) {
                      bool isEnabled = true;
                      switch (item) {
                        case AppModule.cliente:
                          isEnabled = usuario.permission.cliente
                              .contains(UserPermissionType.read);

                          break;
                        case AppModule.pedidos:
                          isEnabled = usuario.permission.pedido
                              .contains(UserPermissionType.read);

                          break;
                        case AppModule.ordens:
                          isEnabled = usuario.permission.ordem
                              .contains(UserPermissionType.read);

                          break;
                        case AppModule.steps:
                          isEnabled = usuario.role == UsuarioRole.administrador;

                          break;
                        case AppModule.tags:
                          isEnabled = usuario.role == UsuarioRole.administrador;
                          break;
                        default:
                      }
                      if (!isEnabled) return const SizedBox();
                      return ListTile(
                        onTap: () {
                          pop(context);
                          baseCtrl.moduleStream.add(item);
                        },
                        leading: Icon(item.icon,
                            color:
                                item == module ? AppColors.primaryMain : null),
                        title: Text(
                          item.label,
                          style: TextStyle(
                              color: item == module
                                  ? AppColors.primaryMain
                                  : null),
                        ),
                      );
                    })
                ],
              ),
            ),
            ListTile(
              onTap: () => usuarioCtrl.clearCurrentUser(),
              leading: Icon(Icons.exit_to_app, color: AppColors.error),
              title: Text(
                'Sair',
                style: TextStyle(color: AppColors.error),
              ),
            )
          ],
        ),
      ),
    );
  }
}
