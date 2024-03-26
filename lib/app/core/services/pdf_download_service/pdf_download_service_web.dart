// import 'dart:html' as html;
import 'dart:typed_data';

import 'package:aco_plus/app/core/services/pdf_download_service/pdf_download_service_platform.dart';

class PdfDownloadServiceWeb extends PdfDownloadServicePlatform {
  @override
  Future<bool> download(String name, Uint8List bytes) async {
    try {
      // List<int> ints = List.from(bytes);
      // html.AnchorElement(
      //     href:
      //         "data:application/octet-stream;charset=utf-16le;base64,${base64.encode(ints)}")
      //   ..setAttribute("download", name)
      //   ..click();
      return true;
    } catch (_) {
      return false;
    }
  }
}
