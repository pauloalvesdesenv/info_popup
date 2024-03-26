import 'dart:typed_data';

abstract class PdfDownloadServicePlatform{
  Future<bool> download(String name, Uint8List bytes);
}