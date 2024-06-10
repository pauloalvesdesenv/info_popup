import 'package:aco_plus/app/core/client/firestore/collections/step/models/step_model.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:flutter/material.dart';

enum KanbanCardStepViewMode {
  collapsed,
  expanded,
}

class KanbanCardStepWidget extends StatefulWidget {
  final KanbanCardStepViewMode viewMode;
  final StepModel step;

  const KanbanCardStepWidget(this.step, {required this.viewMode, super.key});

  @override
  State<KanbanCardStepWidget> createState() => _KanbanCardStepWidgetState();
}

class _KanbanCardStepWidgetState extends State<KanbanCardStepWidget> {
  bool get isCollapsed => widget.viewMode == KanbanCardStepViewMode.collapsed;
  bool get isExpanded => widget.viewMode == KanbanCardStepViewMode.expanded;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
      decoration: BoxDecoration(
        color: widget.step.color.withOpacity(0.2),
        borderRadius: const BorderRadius.all(Radius.circular(4)),
      ),
      child: isCollapsed
          ? SizedBox(
              height: 4,
              width: widget.step.name.length * 3.0,
            )
          : Text(widget.step.name,
              style: AppCss.minimumRegular.copyWith(
                fontSize: 9,
                fontWeight: FontWeight.bold,
                color: widget.step.color.computeLuminance() > 0.2
                    ? Colors.black
                    : Colors.white,
              )),
    );
  }
}
