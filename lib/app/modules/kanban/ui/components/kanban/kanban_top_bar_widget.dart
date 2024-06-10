import 'package:aco_plus/app/core/client/firestore/collections/usuario/enums/user_permission_type.dart';
import 'package:aco_plus/app/core/components/stream_out.dart';
import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:aco_plus/app/core/utils/global_resource.dart';
import 'package:aco_plus/app/modules/base/base_controller.dart';
import 'package:aco_plus/app/modules/kanban/kanban_controller.dart';
import 'package:aco_plus/app/modules/kanban/kanban_view_model.dart';
import 'package:aco_plus/app/modules/pedido/ui/pedido_create_page.dart';
import 'package:aco_plus/app/modules/usuario/usuario_controller.dart';
import 'package:flutter/material.dart';

class KanbanTopBarWidget extends StatelessWidget
    implements PreferredSizeWidget {
  const KanbanTopBarWidget({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return StreamOut<KanbanUtils>(
      stream: kanbanCtrl.utilsStream.listen,
      builder: (_, utils) => AppBar(
        leading: IconButton(
          onPressed: () => baseCtrl.key.currentState!.openDrawer(),
          icon: Icon(
            Icons.menu,
            color: AppColors.white,
          ),
        ),
        title: Text('Kaban', style: AppCss.largeBold.setColor(AppColors.white)),
        actions: [
          IconButton(
              onPressed: () {
                if (utils.view == KanbanViewMode.calendar) {
                  utils.view = KanbanViewMode.kanban;
                } else {
                  utils.view = KanbanViewMode.calendar;
                }
                kanbanCtrl.utilsStream.update();
              },
              icon: Icon(
                utils.view == KanbanViewMode.calendar
                    ? Icons.calendar_month
                    : Icons.view_kanban,
                color: AppColors.white,
              )),
          if (usuario.permission.pedido.contains(UserPermissionType.create))
            IconButton(
                onPressed: () => push(context, const PedidoCreatePage()),
                icon: Icon(
                  Icons.add,
                  color: AppColors.white,
                ))
        ],
        backgroundColor: AppColors.primaryMain,
      ),
    );
  }
}
