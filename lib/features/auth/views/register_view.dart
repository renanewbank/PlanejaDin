import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../widgets/input_field.dart';
import '../../../widgets/primary_button.dart';
import '../../../widgets/back_button_widget.dart';
import '../viewmodels/register_view_model.dart';
import '../../auth/viewmodels/login_view_model.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final nomeController = TextEditingController();
  final emailController = TextEditingController();
  final senhaController = TextEditingController();
  final confirmSenhaController = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RegisterViewModel>().reset();
    });
  }

  @override
  void dispose() {
    nomeController.dispose();
    emailController.dispose();
    senhaController.dispose();
    confirmSenhaController.dispose();
    super.dispose();
  }

  Future<void> _onRegisterPressed(RegisterViewModel registerVM) async {
    final ok = await registerVM.register(
      nomeController.text.trim(),
      emailController.text.trim(),
      senhaController.text,
      confirmSenhaController.text,
    );

    if (ok) {
      try {
        final loginVM = context.read<LoginViewModel>();
        final logged = await loginVM.login(
          emailController.text.trim(),
          senhaController.text,
        );
        if (logged && mounted) {
          Navigator.pushReplacementNamed(context, "/dashboard");
        }
      } catch (_) {
        if (mounted) Navigator.pushReplacementNamed(context, "/dashboard");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final registerVM = context.watch<RegisterViewModel>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // HEADER
                Row(
                  children: const [
                    BackButtonWidget(),
                    SizedBox(width: 12),
                    Text(
                      "Cadastre-se",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                InputField(
                  hint: "Nome do Usuário",
                  controller: nomeController,
                  error: registerVM.nomeError,
                ),
                const SizedBox(height: 14),

                InputField(
                  hint: "Email",
                  controller: emailController,
                  error: registerVM.emailError,
                ),
                const SizedBox(height: 14),

                InputField(
                  hint: "Senha",
                  obscure: true,
                  controller: senhaController,
                  error: registerVM.senhaError,
                ),
                const SizedBox(height: 14),

                InputField(
                  hint: "Confirme sua senha",
                  obscure: true,
                  controller: confirmSenhaController,
                  error: registerVM.confirmSenhaError,
                ),

                const SizedBox(height: 8),

                if (registerVM.errorMessage != null)
                  Text(
                    registerVM.errorMessage!,
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                const SizedBox(height: 25),

                PrimaryButton(
                  text: registerVM.loading ? "Carregando..." : "Cadastrar",
                  onPressed: registerVM.loading
                      ? null
                      : () {
                          _onRegisterPressed(registerVM);
                        },
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Já possui uma conta? "),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Text(
                        "Faça login!",
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
