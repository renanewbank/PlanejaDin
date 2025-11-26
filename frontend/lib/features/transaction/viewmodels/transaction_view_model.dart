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

  // Descrição e método de pagamento (apesar de não existir no backend ainda)
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
      final result = await api.getCategorias(); // chama /categories?user_id=...

      if (result.isEmpty) {
        // Sem categorias do backend (ou ainda não logou) -> usa defaults
        categorias = _defaultCategorias();
      } else {
        categorias = result.map((c) {
          if (c is Map<String, dynamic>) {
            // categoria vinda do backend
            return Categoria.fromJson(Map<String, dynamic>.from(c));
          } else {
            // fallback: alguma string solta
            return Categoria(
              id: c.toString(),
              nome: c.toString(),
              tipo: CategoriaTipo.outro,
            );
          }
        }).toList();
      }

      if (categorias.isNotEmpty) {
        categoria = categorias.first;
      }
      notifyListeners();
    } catch (e) {
      // Em qualquer erro, ainda assim garante lista default
      categorias = _defaultCategorias();
      if (categorias.isNotEmpty) categoria = categorias.first;
      notifyListeners();
      debugPrint("Erro ao carregar categorias: $e");
    }
  }

  List<Categoria> _defaultCategorias() {
    return [
      Categoria(
        id: "local_mercado",
        nome: "Mercado",
        tipo: CategoriaTipo.mercado,
      ),
      Categoria(
        id: "local_salario",
        nome: "Salário",
        tipo: CategoriaTipo.salario,
      ),
      Categoria(
        id: "local_transporte",
        nome: "Transporte",
        tipo: CategoriaTipo.transporte,
      ),
      Categoria(id: "local_lazer", nome: "Lazer", tipo: CategoriaTipo.lazer),
      Categoria(id: "local_outro", nome: "Outro", tipo: CategoriaTipo.outro),
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
      // monta o body básico, SEM category_id por enquanto
      final Map<String, dynamic> body = {
        "type": type == TransactionType.receita ? "INCOME" : "EXPENSE",
        "amount": valor,
        "description": descricao,
        // backend espera date (DATE), não datetime
        "date": data.toIso8601String().substring(0, 10), // "YYYY-MM-DD"
      };

      // Só envia category_id se parecer um UUID (vem do backend)
      if (categoria != null) {
        final cid = categoria!.id;
        // heurística simples: UUID tem hífen e é bem maior que um id "local"
        if (cid.contains('-') && cid.length > 10) {
          body["category_id"] = cid;
        }
      }

      // aqui precisamos mandar user_id via query (?user_id=...)
      final userId = api.userId;
      if (userId == null) {
        throw Exception("Usuário não autenticado");
      }

      await api.post("/transactions?user_id=$userId", body);

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
