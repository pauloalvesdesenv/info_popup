import 'dart:convert';
import 'dart:typed_data';

import 'package:aco_plus/app/core/components/archive/archive_type.dart';
import 'package:http/http.dart';

class ArchiveModel {
  String? name;
  String? url;
  Uint8List? bytes;
  String? description;
  final DateTime createdAt;
  final ArchiveModel? thumbnail;
  final ArchiveType type;
  final String mime;

  ArchiveModel.fromFile({
    required this.bytes,
    required this.createdAt,
    required this.type,
    required this.mime,
    this.thumbnail,
    this.name,
  });

  Future<Uint8List> fetchBytes() async {
    try {
      // final response = await Dio().get(url!,
      //     options: Options(responseType: ResponseType.bytes, headers: {
      //       'Access-Control-Allow-Origin': '*',
      //       'Accept': '*/*',
      //     }));
      final response = await get(
        Uri.parse(url!),
        headers: {
          "Access-Control-Allow-Origin":
              "*", 
          "Access-Control-Allow-Credentials":
              "true",
          "Access-Control-Allow-Headers":
              "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
          "Access-Control-Allow-Methods": "POST, OPTIONS"
        },
      );
      if (response.statusCode != 200) throw Exception('Failed to load file');
      return Uint8List.fromList(response.bodyBytes);
    } catch (e) {
      return Uint8List(0);
    }
  }

  ArchiveModel({
    required this.url,
    required this.description,
    required this.createdAt,
    required this.type,
    required this.mime,
    this.thumbnail,
    this.name,
    this.bytes,
  });

  Map<String, dynamic> toMap() {
    return {
      'url': url,
      'bytes': bytes != null ? base64.encode(bytes!) : null,
      'description': description,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'thumbnail': thumbnail?.toMap(),
      'name': name,
      'type': type.index,
    };
  }

  factory ArchiveModel.fromMap(Map<String, dynamic> map) {
    return ArchiveModel(
      url: map['url'],
      name: map['name'],
      description: map['description'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      thumbnail: map['thumbnail'] != null
          ? ArchiveModel.fromMap(map['thumbnail'])
          : null,
      type: map['type'] != null
          ? ArchiveType.values[map['type']]
          : ArchiveType.undefined,
      mime: map['mime'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ArchiveModel.fromJson(String source) =>
      ArchiveModel.fromMap(json.decode(source));
}
