import 'package:flutter/material.dart';

class H extends StatelessWidget {
  final double height;

  const H(this.height, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: height);
  }
}
