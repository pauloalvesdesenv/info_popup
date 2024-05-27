import 'dart:convert';
import 'dart:developer';

import 'package:aco_plus/app/core/client/firestore/firestore_client.dart';
import 'package:aco_plus/app/core/models/app_stream.dart';
import 'package:aco_plus/app/core/services/backup_download_service/backup_download_web.dart'
    if (dart.library.io) 'package:aco_plus/app/core/services/backup_download_service/backup_download_mobile.dart';
import 'package:aco_plus/app/modules/backup/backup_view_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';

final backupCtrl = BackupController();

class BackupController {
  static final BackupController _instance = BackupController._();

  BackupController._();

  factory BackupController() => _instance;

  final AppStream<List<BackupModel>> backupsStream =
      AppStream<List<BackupModel>>();
  List<BackupModel> get backups => backupsStream.value;
  final AppStream<BackupUtils> utilsStream = AppStream<BackupUtils>();
  BackupUtils get utils => utilsStream.value;

  Future<void> onInit() async {
    onFetch();
  }

  Future<void> onFetch() async {
    final result =
        await FirebaseStorage.instance.ref().child('backups').listAll();
    final backups = result.items.map((e) => BackupModel.fromRef(e)).toList();
    backupsStream.add(backups);
  }

  Future<void> onCreateBackup() async {
    Map<String, dynamic> backup = {};
    onAddCollection(backup, 'clientes',
        FirestoreClient.clientes.data.map((e) => e.toMap()).toList());
    onAddCollection(backup, 'ordens',
        FirestoreClient.ordens.data.map((e) => e.toMap()).toList());
    onAddCollection(backup, 'pedidos',
        FirestoreClient.pedidos.data.map((e) => e.toMap()).toList());
    onAddCollection(backup, 'produtos',
        FirestoreClient.produtos.data.map((e) => e.toMap()).toList());
    onAddCollection(backup, 'usuarios',
        FirestoreClient.usuarios.data.map((e) => e.toMap()).toList());
    final bytes = utf8.encode(json.encode(backup));
    final name =
        'backup_${DateFormat('dd_MM_yyyy_hh_mm_ss').format(DateTime.now())}.json';
    backupDownload(name, 'backups', bytes);
  }

  void onAddCollection(Map<String, dynamic> backup, String key,
      List<Map<String, dynamic>> data) {
    backup.addAll({key: data});
  }

  Future<void> onRestoreBackup() async {
    try {
      final file = await FilePicker.platform.pickFiles();
      if (file == null) return;

      final backup = json.decode(utf8.decode(file.files.first.bytes!));
      await onRestoreCollection(
          FirestoreClient.usuarios.collection, backup['usuarios']);
      await onRestoreCollection(
          FirestoreClient.produtos.collection, backup['produtos']);
      await onRestoreCollection(
          FirestoreClient.clientes.collection, backup['clientes']);
      await onRestoreCollection(
          FirestoreClient.pedidos.collection, backup['pedidos']);
      await onRestoreCollection(
          FirestoreClient.ordens.collection, backup['ordens']);
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> onRestoreCollection(
      CollectionReference<Map<String, dynamic>> collection, List data) async {
    final bacthDelete = FirebaseFirestore.instance.batch();
    for (var query in (await collection.get()).docs) {
      bacthDelete.delete(query.reference);
    }
    await bacthDelete.commit();
    // utils.restoreTitle = 'Restaurando ${collection.id}';
    // utils.restoreLenght = data.length;
    // utilsStream.update();
    final batchAdd = FirebaseFirestore.instance.batch();
    for (final item in data) {
      // utils.restoreIndex++;
      // utilsStream.update();
      // batchAdd.set(collection.doc(item['id']), item);
      await collection.doc(item['id']).set(item);
    }
    // await batchAdd.commit();
  }
}
