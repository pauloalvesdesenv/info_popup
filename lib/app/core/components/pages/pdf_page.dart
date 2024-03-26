// import 'dart:typed_data';

// import 'package:aco_plus/app/core/client/firestore/collections/portaria/portaria_model.dart';
// import 'package:aco_plus/app/core/components/app_scaffold.dart';
// import 'package:aco_plus/app/core/services/firebase_service.dart';
// import 'package:aco_plus/app/core/services/notification_service.dart';
// import 'package:aco_plus/app/core/services/pdf_download_service/pdf_download_service.dart';
// import 'package:aco_plus/app/core/utils/app_colors.dart';
// import 'package:aco_plus/app/core/utils/app_css.dart';
// import 'package:aco_plus/app/core/utils/global_resource.dart';
// import 'package:flutter/material.dart';
// import 'package:overlay_support/overlay_support.dart';
// import 'package:pdfx/pdfx.dart';

// class PdfPage extends StatefulWidget {
//   final PortariaModel portaria;
//   final Uint8List bytes;
//   const PdfPage(this.portaria, this.bytes, {super.key});

//   @override
//   State<PdfPage> createState() => _PdfPageState();
// }

// class _PdfPageState extends State<PdfPage> {
//   late PdfController controller;

//   @override
//   void initState() {
//     controller = PdfController(document: PdfDocument.openData(widget.bytes));
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AppScaffold(
//       backgroundColor: const Color(0xFF525659),
//       appBar: AppBar(
//         leading: IconButton(
//             onPressed: () => pop(context),
//             icon: Icon(
//               Icons.arrow_back,
//               color: AppColors.white,
//             )),
//         centerTitle: false,
//         title: Text('PDF ${widget.portaria.nome.text}',
//             style: AppCss.largeBold.setColor(AppColors.white)),
//         actions: [
//           PopupMenuButton<String>(
//             color: AppColors.white,
//             iconColor: AppColors.white,
//             surfaceTintColor: Colors.transparent,
//             itemBuilder: (_) => [
//               PopupMenuItem(
//                   onTap: () => PdfDownloadService.download(
//                       widget.portaria.fileName, widget.bytes),
//                   child: const Text('Baixar PDF')),
//               PopupMenuItem(
//                   onTap: () async {
//                     final result = await FirebaseService.onUploadPortariaPDF(
//                         widget.portaria.fileName, widget.bytes);
//                     if (result != null) {
//                       NotificationService.showPositive(
//                           'PDF Salvo', 'Este PDF foi atualizado no banco',
//                           position: NotificationPosition.bottom);
//                     } else {
//                       NotificationService.showNegative(
//                           'Erro ao Salvar', 'PDF não foi salvo no banco',
//                           position: NotificationPosition.bottom);
//                     }
//                   },
//                   child: const Text('Salvar Banco')),
//               const PopupMenuItem(
//                   value: 'send', child: Text('Enviar SharePoint')),
//             ],
//           )
//         ],
//         backgroundColor: AppColors.primaryMain,
//       ),
//       body: PdfView(
//         backgroundDecoration: const BoxDecoration(color: Color(0xFF525659)),
//         controller: controller,
//         onDocumentLoaded: (document) {},
//         onPageChanged: (page) {},
//       ),
//     );
//   }
// }
