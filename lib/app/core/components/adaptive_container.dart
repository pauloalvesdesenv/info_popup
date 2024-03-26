import 'package:programacao/app/core/components/stream_out.dart';
import 'package:programacao/app/core/services/keyboard_visible_service.dart';
import 'package:flutter/material.dart';

double? _heightScreen;

class ContainerAdaptive extends StatelessWidget {
  final Widget child;

  const ContainerAdaptive({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints) => StreamOut<bool>(
            stream: KeyboardVisibleService.isVisible.listen,
            child: (context, isVisible) => _body(isVisible, constraints)));
  }

  ListView _body(bool isVisible, BoxConstraints constraints) {
    if (!isVisible) _heightScreen = constraints.maxHeight;
    return ListView(
      padding: EdgeInsets.zero,
      physics: isVisible ? null : const NeverScrollableScrollPhysics(),
      children: [
        SizedBox(
          height: _heightScreen ?? constraints.maxHeight,
          width: double.maxFinite,
          child: child,
        )
      ],
    );
  }
}
