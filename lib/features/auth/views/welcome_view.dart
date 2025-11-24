import 'package:flutter/material.dart';
import 'login_view.dart';
import 'register_view.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(child: Image.asset("assets/images/logo.png", height: 90)),

            const SizedBox(height: 40),

            const Text(
              "Olá, bem-vindo(a)!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xff5A2E98),
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "Aqui você controla as despesas, organiza as contas, define objetivos, recebe dicas exclusivas e garante sua saúde financeira!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 40),

            const Center(
              child: Text(
                "Vamos começar?",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xff2F7A52),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginView()),
                );
              },
              child: const Text("Login"),
            ),

            const SizedBox(height: 10),

            OutlinedButton(
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                side: const BorderSide(color: Color(0xff2F7A52)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RegisterView()),
                );
              },
              child: const Text(
                "Cadastrar",
                style: TextStyle(color: Color(0xff2F7A52)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
