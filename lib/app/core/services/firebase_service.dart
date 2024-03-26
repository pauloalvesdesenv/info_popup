
import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:programacao/app/core/client/firestore/firestore_client.dart';
import 'package:programacao/app/core/models/service_model.dart';
import 'package:programacao/firebase_options.dart';

class FirebaseService implements Service {
  @override
  Future<void> initialize() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      await FirestoreClient.init();
    } catch (_, __) {
      log(_.toString());
      log(__.toString());
    }
  }

  static Future<String?> onUploadPortariaPDF(
      String name, Uint8List bytes) async {
    try {
      final folderRef = FirebaseStorage.instance.ref().child('recording');
      final Reference fileRef = folderRef.child(name);
      await fileRef.putData(
          bytes, SettableMetadata(contentType: 'video/mp4'));
      return await fileRef.getDownloadURL();
    } catch (e) {
      return null;
    }
  }

}
