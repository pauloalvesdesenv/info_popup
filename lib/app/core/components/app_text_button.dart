import 'package:programacao/app/core/components/app_shimmer.dart';
import 'package:programacao/app/core/enums/fill.dart';
import 'package:programacao/app/core/utils/app_colors.dart';
import 'package:programacao/app/core/utils/app_css.dart';
import 'package:flutter/material.dart';

class AppTextButton extends StatefulWidget {
  final String label;
  final Function() onPressed;
  final Fill fill;
  final bool isEnable;
  final IconData? icon;
  final ButtonStyle? style;

  const AppTextButton(
      {required this.label,
      required this.onPressed,
      this.isEnable = true,
      this.fill = Fill.filled,
      this.icon,
      this.style,
      super.key});

  const AppTextButton.filled(
      {required this.label,
      required this.onPressed,
      this.isEnable = true,
      this.fill = Fill.filled,
      this.icon,
      this.style,
      super.key});

  const AppTextButton.outlined(
      {required this.label,
      required this.onPressed,
      this.isEnable = true,
      this.fill = Fill.outlined,
      this.icon,
      super.key,
      this.style});

  @override
  State<AppTextButton> createState() => _AppTextButtonState();
}

class _AppTextButtonState extends State<AppTextButton> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      enable: loading,
      child: widget.icon != null
          ? TextButton.icon(
              style: style,
              onPressed: onPressed,
              label: text,
              icon: Icon(widget.icon),
            )
          : TextButton(
              style: style,
              onPressed: onPressed,
              child: text,
            ),
    );
  }

  Function()? get onPressed => !widget.isEnable
      ? null
      : () async {
          setState(() => loading = true);
          await widget.onPressed.call();
          setState(() => loading = false);
        };

  Widget get text => Text(widget.label);

  ButtonStyle get style {
    if (widget.style != null) {
      return widget.style!.copyWith(
          fixedSize:
              const MaterialStatePropertyAll(Size(double.maxFinite, 43)));
    }
    final outlined = Fill.outlined == widget.fill;
    return ButtonStyle(
      fixedSize: const MaterialStatePropertyAll(Size(double.maxFinite, 43)),
      foregroundColor:
          outlined ? MaterialStatePropertyAll(AppColors.primaryMain) : null,
      backgroundColor:
          outlined ? MaterialStatePropertyAll(AppColors.white) : null,
      shape: outlined
          ? MaterialStatePropertyAll(RoundedRectangleBorder(
              borderRadius: AppCss.radius8,
              side: BorderSide(color: AppColors.primaryMain, width: 2)))
          : null,
    );
  }
}
