import 'dart:convert';

import 'package:aco_plus/app/core/components/app_avatar.dart';
import 'package:aco_plus/app/core/components/comment/comment_model.dart';
import 'package:aco_plus/app/core/components/h.dart';
import 'package:aco_plus/app/core/components/w.dart';
import 'package:aco_plus/app/core/extensions/date_ext.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class CommentWidget extends StatelessWidget {
  final CommentModel comment;

  const CommentWidget({required this.comment, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppAvatar(
          name: comment.user.nome,
        ),
        const W(16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(comment.user.nome, style: AppCss.mediumBold),
                  const W(12),
                  Text(comment.updatedAt.timeAgo(),
                      style: AppCss.mediumRegular
                          .copyWith(color: Colors.grey[800]!, fontSize: 15)),
                  const Spacer(),
                ],
              ),
              const H(8),
              Container(
                width: double.maxFinite,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                    Document.fromJson(json.decode(comment.delta)).toPlainText(),
                    style: AppCss.mediumRegular.copyWith(fontSize: 16)),
              ),
              const H(8),
              Row(
                children: [
                  const Spacer(),
                  Icon(
                    Icons.delete,
                    color: Colors.grey[800],
                  )
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
