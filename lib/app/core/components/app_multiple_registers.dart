import 'package:flutter/material.dart';
import 'package:programacao/app/core/utils/app_css.dart';
import 'package:programacao/app/core/utils/global_resource.dart';

class AppMultipleRegisters<T> extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget createPage;
  final Function(T) editPage;
  final Function(T) onAdd;
  final List<T> itens;
  final Function(T) itemLabel;

  const AppMultipleRegisters({
    required this.icon,
    required this.title,
    required this.createPage,
    required this.editPage,
    required this.onAdd,
    required this.itens,
    required this.itemLabel,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () async {
            final result = await push(context, createPage);
            if (result != null) {
              onAdd(result as T);
            }
          },
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(icon),
            title: Text(
              title,
              style: AppCss.mediumRegular,
            ),
            trailing: const Icon(Icons.add),
          ),
        ),
        for (T item in itens)
          GestureDetector(
            onTap: () => push(context, editPage.call(item)),
            child: ListTile(
              contentPadding: const EdgeInsets.only(left: 8),
              title: Text(
                itemLabel.call(item),
                style: AppCss.minimumRegular,
              ),
              leading: Text(
                (itens.indexOf(item) + 1).toString(),
                style: AppCss.minimumRegular,
              ),
              trailing: const Icon(
                Icons.edit_outlined,
                size: 20,
              ),
            ),
          ),
      ],
    );
  }
}
