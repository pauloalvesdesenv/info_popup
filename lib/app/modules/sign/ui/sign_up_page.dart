import 'package:flutter/material.dart';
import 'package:programacao/app/core/components/app_field.dart';
import 'package:programacao/app/core/components/app_scaffold.dart';
import 'package:programacao/app/core/components/app_text_button.dart';
import 'package:programacao/app/core/components/h.dart';
import 'package:programacao/app/core/utils/app_css.dart';
import 'package:programacao/app/core/utils/global_resource.dart';
import 'package:programacao/app/modules/sign/sign_controller.dart';
import 'package:programacao/app/modules/sign/ui/sign_in_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => SignUpPageState();
}

class SignUpPageState extends State<SignUpPage> {
  final TextEditingController email = TextEditingController();
  final TextEditingController senha = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return body();
  }

  Widget body() {
    return AppScaffold(
      body: Center(
        child: SizedBox(
          width: 300,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const H(20),
              Text('Programação', style: AppCss.largeBold),
              const H(20),
              AppField(
                controller: email,
                label: 'E-mail',
              ),
              const H(20),
              AppField(
                controller: senha,
                label: 'Senha',
                obscure: true,
                maxLines: 1,
                minLines: 1,
              ),
              const H(20),
              AppTextButton(
                label: 'Entrar',
                onPressed: () => signCtrl.onClickLogin(email.text, senha.text),
              ),
              const H(8),
              AppTextButton(
                label: 'Registre-se',
                onPressed: () => push(
                    context, const SignInPage()),
              )
            ],
          ),
        ),
      ),
    );
  }
}
