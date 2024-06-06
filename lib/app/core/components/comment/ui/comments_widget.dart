import 'package:aco_plus/app/core/components/comment/comment_model.dart';
import 'package:aco_plus/app/core/components/comment/comment_quill_model.dart';
import 'package:aco_plus/app/core/components/comment/ui/comment_add_widget.dart';
import 'package:aco_plus/app/core/components/comment/ui/comment_widget.dart';
import 'package:aco_plus/app/core/components/h.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:aco_plus/app/modules/usuario/usuario_controller.dart';
import 'package:flutter/material.dart';

class CommentsWidget extends StatelessWidget {
  final List<CommentModel> items;
  final CommentQuillModel quill;
  final void Function() onChanged;

  const CommentsWidget({
    required this.items,
    required this.quill,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Comentários', style: AppCss.largeBold),
        const H(16),
        Column(
          children: [
            CommentAddWidget(
              quill: quill,
              onSave: (e) {
                items.add(
                  CommentModel(
                    user: usuario,
                    delta: e,
                    isEdited: false,
                    createdAt: DateTime.now(),
                    updatedAt: DateTime.now(),
                    respostas: [],
                  ),
                );
                onChanged();
              },
            ),
            ...items.reversed.map(
              (e) => CommentWidget(
                comment: e,
              ),
            ),
          ],
        )
      ],
    );
  }
}
