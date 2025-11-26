import 'package:flutter/material.dart';
import '../../../core/models/categoria.dart';
import '../../../core/models/transaction.dart';
import '../../../services/api_service.dart';

class TransactionsViewModel extends ChangeNotifier {
  final ApiService api;

  TransactionsViewModel(this.api) {
    _loadCategorias();
  }

  // Tipo de transação
  TransactionType type = TransactionType.despesa;

  // Categoria selecionada
  Categoria? categoria;
  List<Categoria> categorias = [];

  // Data e valor
  DateTime data = DateTime.now();
  double valor = 0.0;

  // Descrição e método de pagamento
  String? descricao;
  String? metodoPagamento = "Pix";

  // Estado da tela
  bool loading = false;
  String? errorMessage;

  // Indica se o campo está inválido (para borda vermelha)
  bool valorInvalido = false;
  bool categoriaInvalida = false;

  // indica se o usuário já tentou enviar
  bool submitTried = false;

  // SETTERS
  void setType(TransactionType t) {
    type = t;
    notifyListeners();
  }

  void setCategoria(Categoria? c) {
    categoria = c;
    categoriaInvalida = false;
    notifyListeners();
  }

  void setData(DateTime d) {
    data = d;
    notifyListeners();
  }

  void setDescricao(String? d) {
    descricao = d;
  }

  void setMetodoPagamento(String? m) {
    metodoPagamento = m;
    notifyListeners();
  }

  void setValor(double v) {
    valor = v;
    if (v > 0) valorInvalido = false;
  }

  // LOAD CATEGORIAS
  Future<void> _loadCategorias() async {
    try {
      final result = await api.get("/categorias");

      if (result is List) {
        categorias = result.map((c) {
          if (c is Map<String, dynamic>) {
            return Categoria.fromJson(Map<String, dynamic>.from(c));
          } else {
            return Categoria(id: 0, nome: c.toString());
          }
        }).toList();
      } else {
        categorias = _defaultCategorias();
      }

      if (categorias.isNotEmpty) categoria = categorias.first;
      notifyListeners();
    } catch (e) {
      categorias = _defaultCategorias();
      if (categorias.isNotEmpty) categoria = categorias.first;
      notifyListeners();
      debugPrint("Erro ao carregar categorias: $e");
    }
  }

  List<Categoria> _defaultCategorias() {
    return [
      Categoria(id: 1, nome: "Mercado"),
      Categoria(id: 2, nome: "Salário"),
      Categoria(id: 3, nome: "Transporte"),
      Categoria(id: 4, nome: "Lazer"),
      Categoria(id: 5, nome: "Outro"),
    ];
  }

  // SUBMIT TRANSACAO
  Future<bool> submit() async {
    submitTried = true;
    bool valido = true;

    if (valor <= 0) {
      valorInvalido = true;
      errorMessage = "Digite um valor válido";
      valido = false;
    }

    if (categoria == null) {
      categoriaInvalida = true;
      errorMessage = "Selecione uma categoria";
      valido = false;
    }

    if (!valido) {
      notifyListeners();
      return false;
    }

    loading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final body = {
        "tipo": type == TransactionType.receita ? "receita" : "despesa",
        "valor": valor,
        "descricao": descricao ?? "",
        "categoria_id": categoria!.id,
        "data": data.toIso8601String(),
        "metodo_pagamento": metodoPagamento,
      };

      await api.post("/transacoes", body);

      loading = false;
      notifyListeners();
      return true;
    } catch (e) {
      loading = false;
      errorMessage = "Erro ao registrar transação";
      notifyListeners();
      debugPrint("Erro submit transacao: $e");
      return false;
    }
  }
}
