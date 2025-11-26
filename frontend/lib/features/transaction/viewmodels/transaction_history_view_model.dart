import 'package:flutter/material.dart';
import 'package:teste/services/api_service.dart';

class TransactionHistoryViewModel extends ChangeNotifier {
  final ApiService api;

  TransactionHistoryViewModel(this.api) {
    loadTransactions();
  }

  List<Map<String, dynamic>> transacoes = [];
  bool loading = false;

  Future<void> loadTransactions() async {
    loading = true;
    notifyListeners();

    try {
      // já vem no formato:
      // [{ "titulo", "categoria", "valor", "data" }, ...]
      final data = await api.getHistorico();

      transacoes = data
          .map<Map<String, dynamic>>(
            (t) => {
              "titulo": t["titulo"],
              "categoria": t["categoria"], // String
              "valor": (t["valor"] as num).toDouble(),
              "data": t["data"],
            },
          )
          .toList();
    } catch (e) {
      print("Erro ao carregar histórico: $e");
    }

    loading = false;
    notifyListeners();
  }

  // Cálculos
  // aqui considero "Salário" como receita.
  bool _isReceita(Map<String, dynamic> t) {
    final categoria = (t["categoria"] ?? "") as String;
    return categoria.toLowerCase() == "salário" ||
        categoria.toLowerCase() == "renda";
  }

  double get receita => transacoes
      .where((t) => _isReceita(t))
      .fold(0.0, (s, t) => s + (t["valor"] as num).toDouble());

  double get despesa => transacoes
      .where((t) => !_isReceita(t))
      .fold(0.0, (s, t) => s + (t["valor"] as num).toDouble())
      .abs();

  double get saldo => receita - despesa;

  Map<String, double> get resumoPorCategoria {
    final resumo = <String, double>{};

    for (var t in transacoes) {
      final categoria = (t["categoria"] ?? "") as String;
      final valor = (t["valor"] as num).toDouble().abs();

      resumo[categoria] = (resumo[categoria] ?? 0) + valor;
    }

    return resumo;
  }
}
