import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teste/features/dicas/viewmodels/dicas_view_model.dart';
import 'package:teste/features/dicas/services/dicas_service.dart';
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
        // ApiService compartilhado para todo mundo
        Provider<ApiService>(create: (_) => ApiService()),

        ChangeNotifierProvider(
          create: (ctx) => LoginViewModel(ctx.read<ApiService>()),
        ),
        ChangeNotifierProvider(
          create: (ctx) => DashboardViewModel(ctx.read<ApiService>()),
        ),
        ChangeNotifierProvider(
          create: (ctx) => RegisterViewModel(ctx.read<ApiService>()),
        ),

        // DicasViewModel usa DicasService, que usa o MESMO ApiService
        ChangeNotifierProvider(
          create: (ctx) => DicasViewModel(DicasService(ctx.read<ApiService>())),
        ),

        ChangeNotifierProvider(
          create: (ctx) => TransactionsViewModel(ctx.read<ApiService>()),
        ),
        ChangeNotifierProvider(
          create: (ctx) => TransactionHistoryViewModel(ctx.read<ApiService>()),
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
