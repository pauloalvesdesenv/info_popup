import 'package:programacao/app/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class DoneButton extends StatefulWidget {
  final Future<void> Function() onPressed;
  const DoneButton(this.onPressed, {super.key});

  @override
  State<DoneButton> createState() => _DoneButtonState();
}

class _DoneButtonState extends State<DoneButton> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () async => await widget.onPressed.call(),
        icon: Icon(
          Icons.done,
          color: AppColors.white,
        ));
  }
}
