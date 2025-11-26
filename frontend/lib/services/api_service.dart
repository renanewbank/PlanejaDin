import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Backend local
  final String baseUrl = "http://localhost:8000";

  // ---- CAMPOS INTERNOS ----
  String? _userId;
  String? _userName;
  String? _userEmail;

  // ---- GETTER PÚBLICO ----
  String? get userId => _userId;

  // ===========================
  // AUTH
  // ===========================
  Future<Map<String, dynamic>> login(String email, String senha) async {
    final url = Uri.parse("$baseUrl/users/login");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": senha}),
    );

    if (response.statusCode != 200) {
      throw Exception("Erro ao fazer login");
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    _userId = data["id"] as String;
    _userName = data["name"] as String;
    _userEmail = data["email"] as String;

    return {"success": true};
  }

  Future<Map<String, dynamic>> register(
    String nome,
    String email,
    String senha,
  ) async {
    final url = Uri.parse("$baseUrl/users/register");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"name": nome, "email": email, "password": senha}),
    );

    if (response.statusCode != 201) {
      throw Exception("Erro ao cadastrar usuário");
    }

    final data = jsonDecode(response.body);
    _userId = data["id"];
    _userName = data["name"];
    _userEmail = data["email"];

    return {"success": true};
  }

  Future<Map<String, dynamic>> getUser() async {
    return {"nome": _userName ?? "Usuário", "email": _userEmail ?? ""};
  }

  // ===========================
  // MÉTODOS GENÉRICOS HTTP
  // ===========================
  Future<dynamic> get(String endpoint) async {
    final url = Uri.parse("$baseUrl$endpoint");

    final resp = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    if (resp.statusCode < 200 || resp.statusCode >= 300) {
      throw Exception("Erro na requisição GET $endpoint: ${resp.statusCode}");
    }

    if (resp.body.isEmpty) return {};
    return jsonDecode(resp.body);
  }

  Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse("$baseUrl$endpoint");

    final resp = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    if (resp.statusCode < 200 || resp.statusCode >= 300) {
      throw Exception("Erro na requisição POST $endpoint: ${resp.statusCode}");
    }

    if (resp.body.isEmpty) return {};
    return jsonDecode(resp.body);
  }

  Future<dynamic> put(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse("$baseUrl$endpoint");

    final resp = await http.put(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    if (resp.statusCode < 200 || resp.statusCode >= 300) {
      throw Exception("Erro na requisição PUT $endpoint: ${resp.statusCode}");
    }

    if (resp.body.isEmpty) return {};
    return jsonDecode(resp.body);
  }

  Future<dynamic> delete(String endpoint) async {
    final url = Uri.parse("$baseUrl$endpoint");

    final resp = await http.delete(
      url,
      headers: {"Content-Type": "application/json"},
    );

    if (resp.statusCode < 200 || resp.statusCode >= 300) {
      throw Exception(
        "Erro na requisição DELETE $endpoint: ${resp.statusCode}",
      );
    }

    if (resp.body.isEmpty) return {};
    return jsonDecode(resp.body);
  }

  // ===========================
  // MÉTODOS ESPECÍFICOS DO APP
  // ===========================
  Future<Map<String, dynamic>> getResumoMes() async {
    final uid = _userId;
    if (uid == null) {
      throw Exception("Usuário não autenticado");
    }

    final now = DateTime.now();
    final url = Uri.parse(
      "$baseUrl/reports/monthly"
      "?user_id=$_userId&year=${now.year}&month=${now.month}",
    );

    final resp = await http.get(url);
    if (resp.statusCode != 200) {
      throw Exception("Erro ao buscar resumo do mês");
    }

    final data = jsonDecode(resp.body);
    return {
      "receitas": data["total_income"],
      "despesas": data["total_expense"],
    };
  }

  Future<Map<String, dynamic>> getSaldo() async {
    final resumo = await getResumoMes();
    final saldo = (resumo["receitas"] as num) - (resumo["despesas"] as num);
    return {"saldo": saldo.toDouble()};
  }

  Future<List<Map<String, dynamic>>> getHistorico() async {
    final uid = _userId;
    if (uid == null) {
      throw Exception("Usuário não autenticado");
    }

    final now = DateTime.now();
    final start = DateTime(now.year, now.month, 1);
    final end = DateTime(now.year, now.month + 1, 0);

    final url = Uri.parse(
      "$baseUrl/transactions"
      "?user_id=$_userId"
      "&date_from=${start.toIso8601String().substring(0, 10)}"
      "&date_to=${end.toIso8601String().substring(0, 10)}",
    );

    final resp = await http.get(url);
    if (resp.statusCode != 200) {
      throw Exception("Erro ao buscar histórico");
    }

    final list = jsonDecode(resp.body) as List;

    String formatDate(String iso) {
      final d = DateTime.parse(iso);
      return "${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}";
    }

    return list.map<Map<String, dynamic>>((t) {
      final isIncome = t["type"] == "INCOME";
      return {
        "titulo": t["description"] ?? (isIncome ? "Receita" : "Despesa"),
        "categoria": isIncome ? "Renda" : "Alimentação",
        "valor": (t["amount"] as num).toDouble(),
        "data": formatDate(t["date"]),
      };
    }).toList();
  }

  Future<List<dynamic>> getCategorias() async {
    // Se ainda não logou, não chama backend.
    // Devolvo lista vazia e o ViewModel cai no _defaultCategorias().
    if (_userId == null) {
      return [];
    }

    final url = Uri.parse("$baseUrl/categories?user_id=$_userId");
    final resp = await http.get(url);

    if (resp.statusCode != 200) {
      throw Exception("Erro ao buscar categorias");
    }

    return jsonDecode(resp.body) as List<dynamic>;
  }
}
