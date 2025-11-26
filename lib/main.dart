import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teste/features/dicas/viewmodels/dicas_view_model.dart';
import 'package:teste/features/transaction/viewmodels/transaction_history_view_model.dart';
import 'package:teste/features/transaction/viewmodels/transaction_view_model.dart';
import 'package:teste/services/api_service.dart';
import 'features/auth/viewmodels/login_view_model.dart';
import 'features/dashboard/viewmodels/dashboard_view_model.dart';
import 'features/auth/viewmodels/register_view_model.dart';
import 'features/auth/views/welcome_view.dart';
import 'features/auth/views/login_view.dart';
import 'features/auth/views/register_view.dart';
import 'features/dashboard/views/dashboard_view.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => DashboardViewModel()),
        ChangeNotifierProvider(create: (_) => RegisterViewModel()),
        ChangeNotifierProvider(create: (_) => DicasViewModel()),
        ChangeNotifierProvider(
          create: (_) => TransactionsViewModel(ApiService()),
        ),
        ChangeNotifierProvider(
          create: (_) => TransactionHistoryViewModel(ApiService()),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "PlanejaDin",
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.green,
        fontFamily: "Arial",
      ),
      initialRoute: "/welcome",
      routes: {
        "/welcome": (context) => const WelcomeView(),
        "/login": (context) => const LoginView(),
        "/register": (context) => const RegisterView(),
        "/dashboard": (context) => const DashboardView(),
      },
    );
  }
}
