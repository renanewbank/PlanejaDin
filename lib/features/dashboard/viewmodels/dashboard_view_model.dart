import 'package:flutter/material.dart';
import '../../../services/api_service.dart';

class DashboardViewModel extends ChangeNotifier {
  final ApiService api = ApiService();

  String nomeUsuario = "Usuário";
  double saldo = 0.0;
  double receitaMes = 0.0;
  double despesaMes = 0.0;
  List<dynamic> historico = [];

  bool loading = true;
  bool saldoVisivel = true;

  Future<void> carregarDados() async {
    loading = true;
    notifyListeners();

    try {
      final usuarioApi = await api.getUser();
      final saldoApi = await api.getSaldo();
      final resumoApi = await api.getResumoMes();
      final historicoApi = await api.getHistorico();

      nomeUsuario = usuarioApi["nome"] ?? "Usuário";
      saldo = saldoApi["saldo"] ?? 0.0;
      receitaMes = resumoApi["receitas"] ?? 0.0;
      despesaMes = resumoApi["despesas"] ?? 0.0;
      historico = historicoApi;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  void toggleSaldo() {
    saldoVisivel = !saldoVisivel;
    notifyListeners();
  }
}
