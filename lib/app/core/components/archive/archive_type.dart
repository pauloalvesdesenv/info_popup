import 'package:flutter/material.dart';

enum ArchiveType { pdf, image, video, undefined }

extension ArchiveTypeExtension on ArchiveType {
  String get name {
    switch (this) {
      case ArchiveType.pdf:
        return 'PDF';
      case ArchiveType.image:
        return 'Imagem';
      case ArchiveType.video:
        return 'Vídeo';
      default:
        return 'Desconhecido';
    }
  }

  IconData get icon {
    switch (this) {
      case ArchiveType.pdf:
        return Icons.picture_as_pdf;
      case ArchiveType.image:
        return Icons.image;
      case ArchiveType.video:
        return Icons.video_library;
      default:
        return Icons.error;
    }
  }
}
