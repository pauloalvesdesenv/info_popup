import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_model.dart';
import 'package:aco_plus/app/core/components/h.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:aco_plus/app/modules/kanban/kanban_controller.dart';
import 'package:aco_plus/app/modules/kanban/kanban_view_model.dart';
import 'package:aco_plus/app/modules/kanban/ui/components/card/kanban_card_calendar_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:separated_column/separated_column.dart';
import 'package:table_calendar/table_calendar.dart';

class KanbanCalendarWidget extends StatefulWidget {
  final KanbanUtils utils;
  const KanbanCalendarWidget(this.utils, {super.key});

  @override
  State<KanbanCalendarWidget> createState() => _KanbanCalendarWidgetState();
}

class _KanbanCalendarWidgetState extends State<KanbanCalendarWidget> {
  @override
  void initState() {
    kanbanCtrl.onMountCalendar();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white.withOpacity(0.5),
      width: double.maxFinite,
      height: double.maxFinite,
      child: SingleChildScrollView(
        child: TableCalendar(
          availableGestures: AvailableGestures.none,
          firstDay: DateTime.utc(2021, 1, 1),
          lastDay: DateTime.utc(2025, 12, 31),
          focusedDay: DateTime.now(),
          rowHeight: 130,
          daysOfWeekHeight: 30,
          calendarFormat: CalendarFormat.month,
          calendarBuilders: CalendarBuilders(
            dowBuilder: (context, day) => Container(
              width: double.maxFinite,
              padding: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                border: Border.all(color: Colors.grey[400]!, width: 0.5),
              ),
              child: Center(
                child: Text(
                  DateFormat('E').format(day),
                  style: AppCss.minimumRegular.copyWith(
                      color: Colors.grey[700],
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                      height: 1),
                ),
              ),
            ),
            // dowBuilder: (context, day) => const SizedBox(),
            defaultBuilder: (context, day, focusedDay) => _defaultBuilder(
              day: day,
              pedidos:
                  widget.utils.calendar[DateFormat('dd/MM/yyyy').format(day)] ??
                      <PedidoModel>[],
              backgroundColor: [6, 7].contains(day.weekday)
                  ? Colors.grey[200]!
                  : Colors.white,
            ),
            todayBuilder: (context, day, focusedDay) => _defaultBuilder(
                day: day,
                pedidos: widget
                        .utils.calendar[DateFormat('dd/MM/yyyy').format(day)] ??
                    <PedidoModel>[],
                backgroundColor: [6, 7].contains(day.weekday)
                    ? const Color(0xFFE3EFF5)
                    : const Color(0xFFE3EFF5)),
            disabledBuilder: (context, day, focusedDay) => _defaultBuilder(
                day: day,
                pedidos: widget
                        .utils.calendar[DateFormat('dd/MM/yyyy').format(day)] ??
                    <PedidoModel>[],
                backgroundColor: const Color(0xFFE3EFF5)),
            outsideBuilder: (context, day, focusedDay) => _defaultBuilder(
              day: day,
              pedidos:
                  widget.utils.calendar[DateFormat('dd/MM/yyyy').format(day)] ??
                      <PedidoModel>[],
              backgroundColor: [6, 7].contains(day.weekday)
                  ? Colors.grey[200]!
                  : Colors.grey[50]!,
            ),
            weekNumberBuilder: (context, weekNumber) => const Text('teste'),
          ),
        ),
      ),
    );
  }

  Container _defaultBuilder({
    required DateTime day,
    required List<PedidoModel> pedidos,
    required Color backgroundColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(
            color: const Color.fromARGB(255, 209, 210, 214).withOpacity(0.8),
            width: 0.25),
      ),
      width: double.maxFinite,
      child: ListView(
        physics: pedidos.isEmpty ? const NeverScrollableScrollPhysics() : null,
        children: [
          Center(
            child: Text(
              DateFormat('d').format(day),
              style: AppCss.minimumRegular.copyWith(
                  color: Colors.grey[900],
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                  height: 1),
            ),
          ),
          const H(8),
          if (pedidos.isNotEmpty)
            SeparatedColumn(
                separatorBuilder: (_, __) => const H(8),
                children:
                    pedidos.map((e) => KanbanCardCalendarWidget(e)).toList()),
        ],
      ),
    );
  }
}
