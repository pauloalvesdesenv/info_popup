// import 'dart:io';

// import 'package:programacao/app/core/services/firebase_service.dart';
// import 'package:flutter/services.dart';
// import 'package:path_provider/path_provider.dart';
// // ignore: depend_on_referenced_packages
// import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
// import 'package:url_launcher/url_launcher_string.dart';

// class FileSaveHelper {
//   static Future<void> saveAndLaunchFile(Uint8List bytes, String name) async {
//     String? path;
//     if (Platform.isAndroid) {
//       final Directory? directory = await getExternalStorageDirectory();
//       if (directory != null) {
//         path = directory.path;
//       }
//     } else if (Platform.isIOS) {
//       final Directory directory = await getApplicationSupportDirectory();
//       path = directory.path;
//     } else {
//       path = await PathProviderPlatform.instance.getApplicationSupportPath();
//     }
//     final File file = File('$  path/$name');
//     await file.writeAsBytes(bytes, flush: true);
//     final url = await FirebaseService.onUploadMusicosXlsx(name, bytes);
//     if (url != null) {
//       launchUrlString(url, mode: LaunchMode.externalApplication);
//     }
//   }
// }
