import 'package:aco_plus/app/core/components/archive/archive_model.dart';
import 'package:flutter/material.dart';

class ArchiveImageWidget extends StatefulWidget {
  final ArchiveModel archive;
  const ArchiveImageWidget(this.archive, {super.key});

  @override
  State<ArchiveImageWidget> createState() => _ArchiveImageWidgetState();
}

class _ArchiveImageWidgetState extends State<ArchiveImageWidget> {
  @override
  Widget build(BuildContext context) {
    return const SizedBox(
        width: 150,
        height: 180,
        child: Center(
          child: Icon(Icons.image),
        )
        // decoration: BoxDecoration(
        //   image: DecorationImage(
        //     image: (widget.archive.bytes != null
        //         ? MemoryImage(widget.archive.bytes!)
        //         : NetworkImage(widget.archive.url!)) as ImageProvider,
        //     fit: BoxFit.cover,
        //   ),
        // ),
        );
  }
}
