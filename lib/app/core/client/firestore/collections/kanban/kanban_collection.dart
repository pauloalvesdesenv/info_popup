import 'dart:developer';

import 'package:aco_plus/app/core/client/firestore/collections/kanban/models/kanban_model.dart';
import 'package:aco_plus/app/core/client/firestore/firestore_client.dart';
import 'package:aco_plus/app/core/models/app_stream.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class KanbanCollection {
  static final KanbanCollection _instance = KanbanCollection._();

  KanbanCollection._();

  factory KanbanCollection() => _instance;
  String name = 'kanban';

  AppStream<KanbanModel> dataStream = AppStream<KanbanModel>();
  KanbanModel get data => dataStream.value;

  CollectionReference<Map<String, dynamic>> get collection =>
      FirebaseFirestore.instance.collection(name);

  Future<void> fetch({bool lock = true, GetOptions? options}) async {
    _isStarted = false;
    await start(lock: false, options: options);
    _isStarted = true;
  }

  bool _isStarted = false;
  Future<void> start({bool lock = true, GetOptions? options}) async {
    if (_isStarted && lock) return;
    _isStarted = true;
    final data = await FirebaseFirestore.instance.collection(name).get();
    dataStream.add(KanbanModel.fromMap(data.docs.first.data()));
  }

  bool _isListen = false;
  Future<void> listen({
    Object? field,
    Object? isEqualTo,
    Object? isNotEqualTo,
    Object? isLessThan,
    Object? isLessThanOrEqualTo,
    Object? isGreaterThan,
    Object? isGreaterThanOrEqualTo,
    Object? arrayContains,
    Iterable<Object?>? arrayContainsAny,
    Iterable<Object?>? whereIn,
    Iterable<Object?>? whereNotIn,
    bool? isNull,
  }) async {
    if (_isListen) return;
    _isListen = true;
    (field != null
            ? collection.where(
                field,
                isEqualTo: isEqualTo,
                isNotEqualTo: isNotEqualTo,
                isLessThan: isLessThan,
                isLessThanOrEqualTo: isLessThanOrEqualTo,
                isGreaterThan: isGreaterThan,
                isGreaterThanOrEqualTo: isGreaterThanOrEqualTo,
                arrayContains: arrayContains,
                arrayContainsAny: arrayContainsAny,
                whereIn: whereIn,
                whereNotIn: whereNotIn,
                isNull: isNull,
              )
            : collection)
        .snapshots()
        .listen((e) {
      dataStream.add(KanbanModel.fromMap(e.docs.first.data()));
    });
  }

  // KanbanModel getById(String id) => data.singleWhere((e) => e.id == id);
  // KanbanProdutoModel getProdutoByKanbanId(String pedidoId, String produtoId) =>
  //     getById(pedidoId).produtos.firstWhere((e) => e.id == produtoId);

  Future<KanbanModel?> add(KanbanModel model) async {
    try {
      await collection.doc(model.id).set(model.toMap());
      return model;
    } catch (_, __) {
      log(_.toString());
      log(__.toString());
      return null;
    }
  }

  Future<KanbanModel?> update() async {
    try {
      await collection.doc('doc').update(data.toMap());
      return data;
    } catch (_, __) {
      log(_.toString());
      log(__.toString());
      return null;
    }
  }

  Future<void> delete(KanbanModel model) async {
    await collection.doc(model.id).delete();
  }
}
