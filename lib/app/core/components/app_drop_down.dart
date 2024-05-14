import 'package:aco_plus/app/core/components/h.dart';
import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:flutter/material.dart';

class AppDropDown<T> extends StatefulWidget {
  final String label;
  final T item;
  final List<T> itens;
  final String Function(T) itemLabel;
  final void Function(T) onSelect;
  final bool required;
  final bool disable;
  final FocusNode? focus;
  final GlobalKey? dropdownKey;

  const AppDropDown({
    required this.label,
    required this.item,
    required this.itens,
    required this.itemLabel,
    required this.onSelect,
    this.focus,
    this.required = true,
    this.disable = false,
    this.dropdownKey,
    super.key,
  });

  @override
  State<AppDropDown<T>> createState() => _AppDropDown<T>();
}

class _AppDropDown<T> extends State<AppDropDown<T>> {
  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: widget.disable,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${widget.label}:${widget.required ? '*' : ''}',
            style: AppCss.smallBold,
          ),
          const H(4),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.neutralMedium),
              borderRadius: AppCss.radius8,
              color: widget.disable
                  ? AppColors.neutralMedium.withOpacity(0.4)
                  : null,
            ),
            child: DropdownButton<T>(
              key: widget.dropdownKey,
              focusNode: widget.focus,
              enableFeedback: true,
              padding: const EdgeInsets.only(left: 8),
              value: widget.item,
              isExpanded: true,
              underline: const SizedBox(),
              onChanged: (_) => widget.onSelect.call(_ as T),
              hint: const Text('Selecione'),
              icon: widget.disable
                  ? const SizedBox()
                  : IgnorePointer(
                      ignoring: widget.item == null,
                      child: InkWell(
                        onTap: () {
                          if (widget.item != null) {
                            widget.onSelect.call(null as T);
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Icon(widget.item != null
                              ? Icons.close
                              : Icons.arrow_drop_down),
                        ),
                      ),
                    ),
              items: widget.itens
                  .map((e) => DropdownMenuItem<T>(
                        value: e,
                        child: Text(widget.itemLabel.call(e)),
                      ))
                  .toList(),
            ),
          ),
          // DropdownButtonFormField2<T>(
          //   isExpanded: true,
          //   focusNode: widget.focus,
          //   decoration: const InputDecoration(
          //     contentPadding: EdgeInsets.symmetric(vertical: 12),
          //   ),
          //   hint: const Text(
          //     'Selecione',
          //     style: TextStyle(fontSize: 16),
          //   ),
          //   value: widget.item,
          //   items: widget.itens
          //       .map((item) => DropdownMenuItem<T>(
          //             value: item,
          //             child: Text(
          //               widget.itemLabel.call(item),
          //               style: const TextStyle(
          //                 fontSize: 16,
          //               ),
          //             ),
          //           ))
          //       .toList(),
          //   onChanged: (value) => widget.onSelect.call(value as T),
          //   buttonStyleData: const ButtonStyleData(
          //     padding: EdgeInsets.only(right: 8),
          //   ),
          //   iconStyleData: const IconStyleData(
          //     icon: Icon(
          //       Icons.arrow_drop_down,
          //       color: Colors.black45,
          //     ),
          //     iconSize: 24,
          //   ),
          //   dropdownStyleData: DropdownStyleData(
          //     decoration: BoxDecoration(
          //       borderRadius: BorderRadius.circular(15),
          //     ),
          //   ),
          //   menuItemStyleData: const MenuItemStyleData(
          //     padding: EdgeInsets.symmetric(horizontal: 16),
          //   ),
          // ),
        ],
      ),
    );
  }

  String label(_) =>
      (_ != null ? (_.label as String) : 'all').replaceAll('\n', ' ');
}
