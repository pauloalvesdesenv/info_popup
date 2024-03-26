import 'package:flutter/material.dart';
import 'package:programacao/app/core/components/stream_out.dart';
import 'package:programacao/app/core/components/w.dart';
import 'package:programacao/app/core/enums/app_module.dart';
import 'package:programacao/app/core/enums/usuario_role.dart';
import 'package:programacao/app/core/utils/app_colors.dart';
import 'package:programacao/app/core/utils/global_resource.dart';
import 'package:programacao/app/modules/base/base_controller.dart';
import 'package:programacao/app/modules/usuario/usuario_controller.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: StreamOut<AppModule>(
        stream: baseCtrl.moduleStream.listen,
        child: (_, module) => Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Stack(
                    alignment: Alignment.topRight,
                    children: [
                      UserAccountsDrawerHeader(
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
                        accountEmail: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.manage_accounts_outlined,
                                color: Colors.white,
                                size: 22,
                              ),
                              const W(8),
                              Text(
                                usuario.role.label,
                                style: const TextStyle(
                                    color: Colors.white,
                                    decoration: TextDecoration.underline),
                              ),
                            ],
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
                          ],
                        ),
                      )
                    ],
                  ),
                  for (var item in usuario.role.modules)
                    ListTile(
                      onTap: () {
                        pop(context);
                        baseCtrl.moduleStream.add(item);
                      },
                      leading: Icon(item.icon,
                          color: item == module ? AppColors.primaryMain : null),
                      title: Text(
                        item.label,
                        style: TextStyle(
                            color:
                                item == module ? AppColors.primaryMain : null),
                      ),
                    )
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
