import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../widgets/input_field.dart';
import '../../../widgets/primary_button.dart';
import '../../../widgets/back_button_widget.dart';
import '../widgets/login_loading_widget.dart';
import '../viewmodels/login_view_model.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final emailController = TextEditingController();
  final senhaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<LoginViewModel>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // HEADER
                  Row(
                    children: [
                      const BackButtonWidget(),
                      const SizedBox(width: 12),
                      const Text(
                        "Entre na sua conta",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  // INPUTS
                  InputField(
                    hint: "Insira o email",
                    controller: emailController,
                    error: vm.loginInvalido,
                  ),
                  const SizedBox(height: 14),
                  InputField(
                    hint: "Insira a senha",
                    controller: senhaController,
                    obscure: true,
                    error: vm.loginInvalido,
                  ),

                  const SizedBox(height: 8),

                  // MENSAGEM DE ERRO
                  if (vm.loginInvalido)
                    Text(
                      vm.errorMessage ?? "E-mail ou senha incorretos",
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                  const SizedBox(height: 8),

                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "Esqueceu a senha?",
                      style: TextStyle(color: Colors.purple),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // BOTÃO LOGIN
                  PrimaryButton(
                    text: "Login",
                    onPressed: vm.carregando
                        ? null
                        : () async {
                            bool ok = await vm.login(
                              emailController.text,
                              senhaController.text,
                            );

                            if (ok) {
                              Navigator.pushReplacementNamed(
                                context,
                                "/dashboard",
                              );
                            }
                          },
                  ),

                  const SizedBox(height: 20),

                  // LINK PARA CADASTRO
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Ainda não tem uma conta? "),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, "/register");
                        },
                        child: const Text(
                          "Cadastre-se!",
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // LOADING
            if (vm.carregando) const LoginLoadingWidget(),
          ],
        ),
      ),
    );
  }
}
