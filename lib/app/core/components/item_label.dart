import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:flutter/material.dart';

class ItemLabel extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;
  final FontWeight? weight;
  final bool isDisable;
  const ItemLabel(this.label, this.value,
      {this.color, this.weight, this.isDisable = false, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: AppCss.minimumBold
                .copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                    color: AppColors.black.withOpacity(0.8))
                .copyWith(
                  decoration: isDisable ? TextDecoration.lineThrough : null,
                  color: isDisable ? AppColors.black.withOpacity(0.3) : null,
                )),
        Text(
          value,
          style:
              AppCss.mediumRegular.setColor(color ?? AppColors.black).copyWith(
                    decoration: isDisable ? TextDecoration.lineThrough : null,
                    color: isDisable ? AppColors.black.withOpacity(0.3) : null,
                  ),
        ),
      ],
    );
  }
}
