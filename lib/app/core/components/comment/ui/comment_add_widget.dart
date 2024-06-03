import 'dart:convert';

import 'package:aco_plus/app/core/components/app_avatar.dart';
import 'package:aco_plus/app/core/components/app_text_button.dart';
import 'package:aco_plus/app/core/components/comment/comment_quill_model.dart';
import 'package:aco_plus/app/core/components/custom_quill/custom_quill_editor.dart';
import 'package:aco_plus/app/core/components/h.dart';
import 'package:aco_plus/app/core/components/w.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:aco_plus/app/modules/usuario/usuario_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class CommentAddWidget extends StatefulWidget {
  final CommentQuillModel quill;
  final void Function(String) onSave;
  const CommentAddWidget(
      {required this.quill, required this.onSave, super.key});

  @override
  State<CommentAddWidget> createState() => _CommentAddWidgetState();
}

class _CommentAddWidgetState extends State<CommentAddWidget> {
  final GlobalKey _quillKey = GlobalKey();
  final QuillController _quillControllerViewer = QuillController.basic();
  final QuillController _quillControllerEditor = QuillController.basic();

  bool _isEditing = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppAvatar(
          name: usuario.nome,
        ),
        const W(16),
        Expanded(
          child: _isEditing ? _editingWidget() : _noEditingWidget(),
        ),
      ],
    );
  }

  Column _editingWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        IntrinsicHeight(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[700]!),
              borderRadius: BorderRadius.circular(4),
            ),
            width: double.maxFinite,
            child: Column(
              children: [
                Theme(
                  data: ThemeData.light(useMaterial3: false),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.grey[200]!,
                    ),
                    padding: const EdgeInsets.all(2),
                    width: double.maxFinite,
                    child: QuillToolbar.simple(
                      configurations: QuillSimpleToolbarConfigurations(
                        controller: _quillControllerViewer,
                        toolbarIconAlignment: WrapAlignment.start,
                        toolbarIconCrossAlignment: WrapCrossAlignment.start,
                        showFontFamily: false,
                        showListCheck: false,
                        showCodeBlock: false,
                        showInlineCode: false,
                        showColorButton: false,
                        showBackgroundColorButton: false,
                        showSearchButton: false,
                        showLink: false,
                        showIndent: false,
                        showRightAlignment: false,
                        showDirection: false,
                        showDividers: false,
                        showStrikeThrough: false,
                        showSubscript: false,
                        showUnderLineButton: false,
                        showAlignmentButtons: false,
                        showListBullets: false,
                        showSuperscript: false,
                        showClearFormat: false,
                        showQuote: false,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: double.maxFinite,
                  height: 1,
                  color: Colors.black38,
                ),
                Expanded(
                  child: CustomQuillEditor(
                    controller: _quillControllerEditor,
                    keyForPosition: _quillKey,
                  ),
                ),
              ],
            ),
          ),
        ),
        const H(8),
        SizedBox(
          width: 100,
          child: AppTextButton(
            isEnable:
                _quillControllerViewer.plainTextEditingValue.text.isNotEmpty,
            onPressed: () {
              setState(() {
                widget.onSave(json.encode(
                    _quillControllerEditor.document.toDelta().toJson()));
                _isEditing = false;
              });
            },
            label: 'Salvar',
          ),
        )
      ],
    );
  }

  Widget _noEditingWidget() => InkWell(
        onTap: () => setState(() {
          _isEditing = true;
        }),
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          width: double.maxFinite,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text('Escrever um comentário...',
              style: AppCss.mediumRegular.copyWith(fontSize: 16)),
        ),
      );
}
