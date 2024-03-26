import 'package:aco_plus/app/core/services/pdf_download_service/pdf_download_service_mobile.dart';
import 'package:aco_plus/app/core/services/pdf_download_service/pdf_download_service_web.dart';
import 'package:flutter/foundation.dart';

class PdfDownloadService {
  static Future<bool> download(String name, Uint8List bytes) async {
    final impl = kIsWeb ? PdfDownloadServiceWeb() : PdfDownloadServiceMobile();
    return impl.download(name, bytes);
  }
}
