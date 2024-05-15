import 'package:aco_plus/app/core/components/app_field.dart';
import 'package:aco_plus/app/core/extensions/date_ext.dart';
import 'package:flutter/material.dart';

class DatePickerField extends StatelessWidget {
  final String label;
  final DateTime? item;
  final Function(DateTime) onChanged;
  final bool required;

  const DatePickerField(
      {required this.label,
      required this.item,
      required this.onChanged,
      required this.required,
      super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final now = DateTime.now();
        final first = now;
        final lats = now.add(const Duration(days: 365));
        FocusManager.instance.primaryFocus?.unfocus();
        final result = await showDatePicker(
            context: context, firstDate: first, lastDate: lats);
        if (result == null) return;
        onChanged.call(result);
      },
      child: IgnorePointer(
        ignoring: true,
        child: AppField(
          label: label,
          required: required,
          hint: '00/00/0000',
          type: TextInputType.number,
          controller: item.textEC(),
          suffixIcon: Icons.calendar_month,
        ),
      ),
    );
  }
}
