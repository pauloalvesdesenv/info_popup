import 'package:flutter/material.dart';

class W extends StatelessWidget {
  final double width;

  const W(this.width, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: width);
  }
}
