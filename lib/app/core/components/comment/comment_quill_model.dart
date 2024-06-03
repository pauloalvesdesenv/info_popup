import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class CommentQuillModel {
  final GlobalKey quillKey = GlobalKey();
  final GlobalKey quillKeyForPos = GlobalKey();
  final QuillController quillControllerViewer = QuillController.basic();
  final QuillController quillControllerEditor = QuillController.basic();
}
