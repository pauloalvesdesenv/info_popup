import 'package:flutter/material.dart';
import 'package:aco_plus/app/core/components/app_container.dart';
import 'package:aco_plus/app/core/components/h.dart';
import 'package:aco_plus/app/core/components/w.dart';
import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';

class AppDropDownList<T> extends StatefulWidget {
  final String label;
  final List<T> itens;
  final List<T> addeds;
  final String Function(T) itemLabel;
  final void Function() onChanged;
  final bool required;
  final bool enable;

  const AppDropDownList({
    required this.label,
    required this.itens,
    required this.addeds,
    required this.onChanged,
    required this.itemLabel,
    this.required = true,
    this.enable = true,
    super.key,
  });

  @override
  State<AppDropDownList<T>> createState() => _AppDropDownList<T>();
}

class _AppDropDownList<T> extends State<AppDropDownList<T>> {
  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !widget.enable,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.label.isNotEmpty)
            Text(
              '${widget.label}:${widget.required ? '*' : ''}',
              style: AppCss.smallBold,
            ),
          if (widget.label.isNotEmpty) const H(4),
          Container(
            decoration: BoxDecoration(
              color: widget.enable ? null : AppColors.black.withOpacity(0.3),
              border: Border.all(color: AppColors.neutralMedium),
              borderRadius: AppCss.radius8,
            ),
            child: DropdownButton<T>(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              isExpanded: true,
              underline: const SizedBox(),
              onChanged: (_) {
                widget.addeds.add(_ as T);
                widget.onChanged.call();
              },
              hint: Text(widget.addeds.length == widget.itens.length
                  ? 'Todos os itens foram selecionados'
                  : 'Selecione Multiplos'),
              items: widget.itens
                  .where((e) => !widget.addeds.contains(e))
                  .map((e) => DropdownMenuItem<T>(
                        value: e,
                        child: Text(widget.itemLabel.call(e)),
                      ))
                  .toList(),
            ),
          ),
          if (widget.enable) const H(8),
          if (widget.enable)
            widget.addeds.isEmpty
                ? InkWell(
                    onTap: () {
                      widget.addeds.clear();
                      widget.addeds.addAll(widget.itens);
                      widget.onChanged.call();
                    },
                    child: Container(
                      height: 30,
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.neutralLight),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'Adicionar Todos',
                        style: TextStyle(color: AppColors.neutralDark),
                      ),
                    ),
                  )
                : SizedBox(
                    width: double.maxFinite,
                    height: 30,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: widget.addeds
                          .map((e) => Container(
                                margin: const EdgeInsets.only(right: 8),
                                child: AppContainer(
                                  padding: const [6, 4],
                                  radius: 4,
                                  color: AppColors.primaryMedium,
                                  child: Row(
                                    children: [
                                      Text(
                                        widget.itemLabel.call(e),
                                        style: TextStyle(color: AppColors.white),
                                      ),
                                      const W(4),
                                      InkWell(
                                        onTap: () {
                                          widget.addeds.remove(e);
                                          widget.onChanged.call();
                                        },
                                        child: Icon(
                                          Icons.close,
                                          color: AppColors.white,
                                          size: 20,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                  ),
        ],
      ),
    );
  }
}
