import 'package:programacao/app/core/utils/app_colors.dart';
import 'package:programacao/app/core/utils/app_css.dart';
import 'package:programacao/app/core/utils/global_resource.dart';
import 'package:flutter/material.dart';

class AppBarBottom extends StatelessWidget {
  final String label;
  final List<Widget> actions;
  const AppBarBottom(this.label, {this.actions = const [], super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Stack(
        children: [
          Align(
              alignment: Alignment.centerLeft,
              child: InkWell(
                onTap: () => pop(context),
                child: Icon(
                  Icons.keyboard_backspace,
                  color: AppColors.neutralMedium,
                ),
              )),
          Align(
            alignment: Alignment.center,
            child: Text(
              label,
              style: AppCss.mediumBold,
            ),
          ),
          Align(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: actions,
              )),
        ],
      ),
    );
  }
}
