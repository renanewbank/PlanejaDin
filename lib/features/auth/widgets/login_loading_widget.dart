import 'package:flutter/material.dart';

class LoginLoadingWidget extends StatelessWidget {
  const LoginLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back_ios_new, size: 22),
                  padding: const EdgeInsets.all(12),
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(
                      const Color(0x0F000000),
                    ),
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Estamos preparando tudo\npara você...",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 60),

                    SizedBox(
                      width: 60,
                      height: 60,
                      child: CircularProgressIndicator(
                        strokeWidth: 5,
                        valueColor: AlwaysStoppedAnimation(Color(0xFFBFA8F4)),
                      ),
                    ),

                    const SizedBox(height: 60),

                    const Text(
                      "Logo você poderá começar.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15, color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
