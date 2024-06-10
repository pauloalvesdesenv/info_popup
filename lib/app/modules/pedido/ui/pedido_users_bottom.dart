import 'package:aco_plus/app/core/client/firestore/collections/pedido/enums/pedido_status.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_model.dart';
import 'package:aco_plus/app/core/client/firestore/firestore_client.dart';
import 'package:aco_plus/app/core/components/app_avatar.dart';
import 'package:aco_plus/app/core/components/h.dart';
import 'package:aco_plus/app/core/components/stream_out.dart';
import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:aco_plus/app/core/utils/global_resource.dart';
import 'package:aco_plus/app/modules/pedido/pedido_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

Future<PedidoStatus?> showPedidoUsersBottom(PedidoModel pedido) async =>
    showModalBottomSheet(
      backgroundColor: AppColors.white,
      context: contextGlobal,
      isScrollControlled: true,
      builder: (_) => PedidoUsersBottom(pedido),
    );

class PedidoUsersBottom extends StatefulWidget {
  final PedidoModel pedido;
  const PedidoUsersBottom(this.pedido, {super.key});

  @override
  State<PedidoUsersBottom> createState() => _PedidoUsersBottomState();
}

class _PedidoUsersBottomState extends State<PedidoUsersBottom> {
  late PedidoStatus currentStatus;

  @override
  void initState() {
    currentStatus = widget.pedido.statusess.last.status;
    super.initState();
  }

  @override
  void dispose() {
    FocusManager.instance.primaryFocus?.unfocus();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
        onClosing: () {},
        builder: (context) =>
            KeyboardVisibilityBuilder(builder: (context, isVisible) {
              return StreamOut(
                  stream: pedidoCtrl.pedidoStream.listen,
                  builder: (context, pedido) {
                    return Container(
                      height: 390,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(24),
                            topRight: Radius.circular(24)),
                      ),
                      child: ListView(
                        children: [
                          const H(16),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: IconButton(
                                style: ButtonStyle(
                                    padding: const WidgetStatePropertyAll(
                                        EdgeInsets.all(16)),
                                    backgroundColor:
                                        WidgetStatePropertyAll(AppColors.white),
                                    foregroundColor: WidgetStatePropertyAll(
                                        AppColors.black)),
                                onPressed: () => Navigator.pop(context),
                                icon: const Icon(Icons.keyboard_backspace),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Adicionar Membros',
                                  style: AppCss.largeBold,
                                ),
                                const H(16),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    for (var user
                                        in FirestoreClient.usuarios.data)
                                      Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 8),
                                        decoration: BoxDecoration(
                                            color: Colors.grey[300],
                                            borderRadius:
                                                BorderRadius.circular(4)),
                                        child: CheckboxListTile(
                                          contentPadding: EdgeInsets.zero,
                                          dense: false,
                                          materialTapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                          visualDensity: VisualDensity.compact,
                                          secondary: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 8),
                                            child: AppAvatar(
                                              backgroundColor: Colors.grey[200],
                                              name: user.nome,
                                              radius: 16,
                                            ),
                                          ),
                                          title: Text(user.nome,
                                              style: AppCss.mediumRegular),
                                          value: widget.pedido.users
                                              .map((e) => e.id)
                                              .contains(user.id),
                                          onChanged: (value) {
                                            setState(() {
                                              if (value!) {
                                                widget.pedido.users.add(user);
                                              } else {
                                                widget.pedido.users.removeWhere(
                                                    (e) => e.id == user.id);
                                              }
                                              pedidoCtrl
                                                  .updatePedidoFirestore();
                                            });
                                          },
                                        ),
                                      ),
                                    const H(16),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  });
            }));
  }
}
