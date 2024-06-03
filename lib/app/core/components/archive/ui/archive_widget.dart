import 'package:aco_plus/app/core/components/archive/archive_model.dart';
import 'package:aco_plus/app/core/components/archive/archive_type.dart';
import 'package:aco_plus/app/core/components/archive/ui/archive_type_widgets/archive_image_widget.dart';
import 'package:aco_plus/app/core/components/archive/ui/archive_type_widgets/archive_pdf_widget.dart';
import 'package:aco_plus/app/core/components/archive/ui/archive_type_widgets/archive_video_widget.dart';
import 'package:aco_plus/app/core/components/w.dart';
import 'package:aco_plus/app/core/services/download_file_url_service/download_file_url_service.dart';
import 'package:flutter/material.dart';

class ArchiveWidget extends StatelessWidget {
  final ArchiveModel archive;
  final bool inList;
  const ArchiveWidget(this.archive, {required this.inList, super.key});

  @override
  Widget build(BuildContext context) {
    if (inList) {
      return _itemRow(context);
    } else {
      return _itemWidget();
    }
  }

  Widget _itemRow(BuildContext context) {
    return InkWell(
      onTap: () => DownloadFileURLService.call(archive.url!),
      child: Row(
        children: [
          _itemWidget(),
          const W(8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(archive.name ?? 'Sem nome'),
                const W(4),
                Text(archive.description ?? 'Sem descrição'),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _itemWidget() {
    switch (archive.type) {
      case ArchiveType.image:
        return ArchiveImageWidget(archive);
      case ArchiveType.video:
        return ArchiveVideoWidget(archive);
      case ArchiveType.pdf:
        return ArchivePDFWidget(archive, inList: inList);
      default:
        return const SizedBox();
    }
  }
}
