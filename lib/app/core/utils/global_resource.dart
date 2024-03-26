import 'package:flutter/material.dart';
import 'package:programacao/app/app_controller.dart';

const String empty = '';

BuildContext get contextGlobal => AppController().context;

dynamic push([a, b]) async {
  Widget? widget;
  BuildContext? context;
  if (a != null) {
    if (a is Widget) {
      widget = a;
    }
  } else {
    context = a;
  }
  if (b != null) {
    if (b is Widget) {
      widget = b;
    }
  } else {
    context = b;
  }
  var result = await Navigator.push(context ?? contextGlobal,
      MaterialPageRoute(builder: (_) => widget ?? Container()));
  return result;
}

void pop([BuildContext? context]) => Navigator.pop(context ?? contextGlobal);

pops(BuildContext context, int length) {
  for (var i = 0; i < length; i++) {
    Navigator.pop(context);
  }
}

void showDialogAndPush(context, Widget dialog, Widget page) async {
  await showDialog(context: context, builder: (_) => dialog);
  push(context, page);
}

bool kIsLayoutMobile = true;
