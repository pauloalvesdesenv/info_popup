import 'dart:developer';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

class FirebaseService {
  static Future<String?> onUploadPortariaPDF(String name, Uint8List bytes) async {
    try {
      final folderRef = FirebaseStorage.instance.ref().child('portarias');
      final list = (await folderRef.list()).items;
      for (var e in list) {
        if (e.name.split('_').first == e.fullPath.split('/')[1].split('_')[0]) {
          try {
            await folderRef.child(e.name).delete();
            break;
          } catch (_) {
            log(_.toString());
          }
        }
      }
      final Reference fileRef = folderRef.child(name);
      await fileRef.putData(bytes, SettableMetadata(contentType: 'application/pdf'));
      return await fileRef.getDownloadURL();
    } catch (e) {
      return null;
    }
  }
}
