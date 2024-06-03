import 'package:aco_plus/app/core/extensions/string_ext.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:flutter/material.dart';

class AppAvatar extends StatelessWidget {
  final String? name;
  final String? url;
  const AppAvatar({this.url, this.name, super.key});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 20,
      child: getChild(),
    );
  }

  Widget getChild() {
    if (url != null) {
      return Image.network(url!);
    }
    if (name != null) {
      return Text(
        name!.getInitials(),
        style: AppCss.mediumBold,
      );
    }
    return const Icon(Icons.person, size: 16);
  }
}
