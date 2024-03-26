import 'dart:typed_data';

import 'package:programacao/app/core/services/firebase_service.dart';
import 'package:programacao/app/core/services/pdf_download_service/pdf_download_service_platform.dart';
import 'package:url_launcher/url_launcher_string.dart';

class PdfDownloadServiceMobile extends PdfDownloadServicePlatform {
  @override
  Future<bool> download(String name, Uint8List bytes) async {
    try {
      final result = await FirebaseService.onUploadPortariaPDF(name, bytes);
      if (result == null) return false;
      launchUrlString(result, mode: LaunchMode.externalApplication);
      return true;
    } catch (_) {
      return false;
    }
  }
}
