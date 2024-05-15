import 'dart:convert';
import 'dart:html' as html;
import 'dart:typed_data';

Future<bool> downloadPDF(String name, String path, Uint8List bytes) async {
  try {
    List<int> fileInts = List.from(bytes);
    html.AnchorElement(
        href:
            "data:application/octet-stream;charset=utf-16le;base64,${base64.encode(fileInts)}")
      ..setAttribute("download", name)
      ..click();
    return true;
  } catch (_) {
    return false;
  }
}
