import 'package:programacao/app/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class FabAdd extends StatelessWidget {
  final Function() onPressed;
  const FabAdd({required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      backgroundColor: AppColors.primaryMain,
      child: Icon(
        Icons.add,
        color: AppColors.white,
        size: 34,
      ),
    );
  }
}
