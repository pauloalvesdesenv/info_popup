import 'package:flutter/material.dart';
import 'package:programacao/app/core/components/h.dart';
import 'package:programacao/app/core/utils/app_css.dart';

class EmptyData extends StatelessWidget {
  const EmptyData({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.network(
          'https://www.shareicon.net/data/512x512/2017/04/28/885353_folder_512x512.png',
          width: 120,
          height: 120,
        ),
        const H(16),
        Text(
          'Nenhum dado encontrado',
          style: AppCss.mediumRegular,
        ),
      ],
    );
  }
}
