import 'package:aco_plus/app/core/components/h.dart';
import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppField extends StatefulWidget {
  final TextEditingController controller;
  final String? label;
  final String hint;
  final TextInputAction? action;
  final FocusNode? focus;
  final IconData? icon;
  final IconData? suffixIcon;
  final double? suffixIconSize;
  final Function()? onSuffix;
  final IconData? prefixIcon;
  final Function()? onPrefix;
  final List<TextInputFormatter>? inputFormatters;
  final void Function(String)? onChanged;
  final void Function()? onEditingComplete;
  final void Function()? onTap;
  final TextInputType type;
  final bool autoFocus;
  final bool required;
  final TextAlign align;
  final int? maxLines;
  final int? minLines;
  final bool ignore;
  final bool obscure;

  const AppField({
    required this.controller,
    this.label,
    this.align = TextAlign.left,
    this.onChanged,
    this.icon,
    this.suffixIcon,
    this.suffixIconSize,
    this.prefixIcon,
    this.hint = '',
    this.focus,
    this.action,
    this.inputFormatters,
    this.onEditingComplete,
    this.onSuffix,
    this.onPrefix,
    this.onTap,
    this.type = TextInputType.text,
    this.autoFocus = false,
    this.required = true,
    this.ignore = false,
    this.maxLines,
    this.minLines,
    this.obscure = false,
    super.key,
  });

  @override
  State<AppField> createState() => _AppFieldState();
}

class _AppFieldState extends State<AppField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null)
          Text(
            '${widget.label!}:${widget.required ? '*' : ''}',
            style: AppCss.smallBold,
          ),
        if (widget.label != null) const H(4),
        IgnorePointer(
          ignoring: widget.ignore,
          child: TextFormField(
            obscureText: widget.obscure,
            textAlign: widget.align,
            onTap: widget.onTap,
            focusNode: widget.focus,
            autofocus: widget.autoFocus,
            controller: widget.controller,
            inputFormatters: widget.inputFormatters,
            keyboardType: widget.type,
            textInputAction: widget.action,
            textCapitalization: TextCapitalization.sentences,
            style: AppCss.smallRegular,
            cursorColor: AppColors.neutralDark,
            onEditingComplete: widget.onEditingComplete,
            onChanged: widget.onChanged ?? (e) {},
            maxLines: widget.maxLines,
            minLines: widget.minLines,
            decoration: InputDecoration(
              filled: true,
              fillColor: widget.ignore ? Colors.grey[400]! : Colors.transparent,
              hintText: widget.hint,
              hintStyle: AppCss.smallRegular.setColor(AppColors.neutralDark),
              prefixIcon: widget.icon != null
                  ? Padding(
                      padding: const EdgeInsets.only(left: 20, right: 10),
                      child: Icon(
                        widget.icon,
                        weight: 800,
                        color: AppColors.primaryDark,
                      ),
                    )
                  : null,
              suffixIcon: widget.suffixIcon != null
                  ? InkWell(
                      onTap: widget.onSuffix,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20, right: 10),
                        child: Icon(widget.suffixIcon,
                            weight: 800,
                            size: widget.suffixIconSize,
                            color: AppColors.neutralMedium),
                      ),
                    )
                  : null,
            ),
          ),
        ),
      ],
    );
  }
}
