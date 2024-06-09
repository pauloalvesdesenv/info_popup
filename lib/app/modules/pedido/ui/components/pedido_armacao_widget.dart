import 'package:aco_plus/app/core/client/firestore/collections/pedido/enums/pedido_status.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_status_model.dart';
import 'package:aco_plus/app/core/components/h.dart';
import 'package:aco_plus/app/core/extensions/date_ext.dart';
import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:flutter/material.dart';

class PedidoArmacaoWidget extends StatelessWidget {
  final PedidoModel pedido;
  const PedidoArmacaoWidget(this.pedido, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Armação', style: AppCss.largeBold),
          const H(16),
          for (PedidoStatusModel status
              in pedido.statusess.map((e) => e.copyWith()).toList())
            Builder(builder: (context) {
              final isLast = status.id == pedido.statusess.last.id;
              if (status.status == PedidoStatus.produzindoCD) {
                status.status = PedidoStatus.aguardandoProducaoCD;
              }
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color:
                            status.status.color.withOpacity(isLast ? 0.4 : 0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(status.status.label,
                          style: AppCss.mediumRegular.setSize(14).setColor(
                              AppColors.black.withOpacity(isLast ? 1 : 0.4))),
                    ),
                    Text(status.createdAt.textHour(),
                        style: AppCss.minimumRegular.setColor(
                            AppColors.black.withOpacity(isLast ? 1 : 0.4))),
                  ],
                ),
              );
            })
        ],
      ),
    );
  }
}
