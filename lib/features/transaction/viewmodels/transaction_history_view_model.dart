import 'package:flutter/material.dart';
import 'package:teste/services/api_service.dart';
import '../../../core/models/categoria.dart';

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
      final data = await api.getHistorico();

      transacoes = data.map<Map<String, dynamic>>((t) {
        final categoria = parseCategoriaTipo(t["categoria"]);

        return {
          "titulo": t["titulo"],
          "categoria": categoria,
          "valor": t["valor"],
          "data": t["data"],
        };
      }).toList();
    } catch (e) {
      print("Erro ao carregar histórico: $e");
    }

    loading = false;
    notifyListeners();
  }

  // Cálculos
  double get receita => transacoes
      .where((t) => (t["categoria"] as CategoriaTipo) == CategoriaTipo.salario)
      .fold(0.0, (s, t) => s + t["valor"].toDouble());

  double get despesa => transacoes
      .where((t) => (t["categoria"] as CategoriaTipo) != CategoriaTipo.salario)
      .fold(0.0, (s, t) => s + t["valor"].toDouble())
      .abs();

  double get saldo => receita - despesa;

  Map<String, double> get resumoPorCategoria {
    final resumo = <String, double>{};

    for (var t in transacoes) {
      final categoria = (t["categoria"] as CategoriaTipo).label;
      final valor = t["valor"].abs();

      resumo[categoria] = (resumo[categoria] ?? 0) + valor;
    }

    return resumo;
  }
}
