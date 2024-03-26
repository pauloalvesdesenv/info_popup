import 'package:flutter/material.dart';
import 'package:aco_plus/app/core/components/w.dart';
import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';

class AppCheckbox extends StatelessWidget {
  final String label;
  final bool value;
  final Function(bool) onChanged;

  const AppCheckbox({
    required this.label,
    required this.value,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onChanged.call(!value);
      },
      child: Row(
        children: [
          Container(
            width: 19,
            height: 19,
            decoration: BoxDecoration(
                color: value ? AppColors.primaryMain : Colors.white,
                border: Border.all(
                  color: value ? AppColors.primaryMain : AppColors.black,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(2)),
            child: Icon(
              Icons.done,
              size: 14,
              color: value ? AppColors.white : Colors.transparent,
            ),
          ),
          const W(12),
          Expanded(
            child: Text(
              label,
              style: AppCss.mediumRegular,
            ),
          )
        ],
      ),
    );
  }
}
