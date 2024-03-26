import 'package:programacao/app/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class Back extends StatelessWidget {
  final bool isOnlyIcon;
  const Back({this.isOnlyIcon = false, super.key});
  const Back.icon({this.isOnlyIcon = true, super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: isOnlyIcon
          ? InkWell(
              onTap: () => Navigator.pop(context),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.keyboard_backspace,
                  color: AppColors.black,
                ),
              ),
            )
          : TextButton.icon(
              onPressed: () => Navigator.pop(context),
              style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(AppColors.white),
                  foregroundColor:
                      MaterialStatePropertyAll(AppColors.primaryMain),
                  fixedSize: const MaterialStatePropertyAll(Size(80, 50)),
                  padding: const MaterialStatePropertyAll(
                      EdgeInsets.symmetric(horizontal: 1, vertical: 0))),
              icon: Icon(
                Icons.arrow_back,
                color: AppColors.primaryMain,
                size: 20,
              ),
              label: const Text('back'),
            ),
    );
  }
}
