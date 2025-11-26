// lib/features/dashboard/viewmodels/dashboard_view_model.dart
import 'package:flutter/material.dart';
import '../../../services/api_service.dart';

class DashboardViewModel extends ChangeNotifier {
  final ApiService api;

  DashboardViewModel(this.api);

  bool loading = false;
  bool saldoVisivel = true;

  String nomeUsuario = "Usuário";
  double receitaMes = 0.0;
  double despesaMes = 0.0;
  double saldo = 0.0;

  List<Map<String, dynamic>> historico = [];

  Future<void> carregarDados() async {
    loading = true;
    notifyListeners();

    try {
      // nome
      final user = await api.getUser();
      nomeUsuario = (user["nome"] ?? "Usuário").toString();

      // resumo do mês
      final resumo = await api.getResumoMes();
      receitaMes = (resumo["receitas"] as num).toDouble();
      despesaMes = (resumo["despesas"] as num).toDouble();

      // saldo
      final saldoResp = await api.getSaldo();
      saldo = (saldoResp["saldo"] as num).toDouble();

      // histórico simples (já formatado pelo ApiService)
      historico = await api.getHistorico();
    } catch (e) {
      debugPrint("Erro ao carregar dashboard: $e");
    }

    loading = false;
    notifyListeners();
  }

  void toggleSaldo() {
    saldoVisivel = !saldoVisivel;
    notifyListeners();
  }
}
