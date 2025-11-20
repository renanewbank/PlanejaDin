// API REAL (BACKEND)

// import 'dart:convert';
// import 'package:http/http.dart' as http;

// class ApiService {
//   final String baseUrl = "http://localhost:8000";

//   // LOGIN
//   Future<Map<String, dynamic>> login(String email, String senha) async {
//     final url = Uri.parse("$baseUrl/login");

//     final response = await http.post(
//       url,
//       headers: {"Content-Type": "application/json"},
//       body: jsonEncode({"email": email, "senha": senha}),
//     );

//     if (response.statusCode != 200) {
//       throw Exception("Erro ao fazer login");
//     }

//     return jsonDecode(response.body);
//   }

//   // REGISTRO
//   Future<Map<String, dynamic>> register(
//     String nome,
//     String email,
//     String senha,
//   ) async {
//     final url = Uri.parse("$baseUrl/register");

//     final response = await http.post(
//       url,
//       headers: {"Content-Type": "application/json"},
//       body: jsonEncode({"nome": nome, "email": email, "senha": senha}),
//     );

//     if (response.statusCode != 200) {
//       throw Exception("Erro ao cadastrar usuário");
//     }

//     return jsonDecode(response.body);
//   }

//   // MÉTODOS (GET/POST/PUT/DELETE)
//   Future<dynamic> get(String endpoint) async {
//     final response = await http.get(Uri.parse("$baseUrl$endpoint"));
//     return jsonDecode(response.body);
//   }

//   Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
//     final response = await http.post(
//       Uri.parse("$baseUrl$endpoint"),
//       headers: {"Content-Type": "application/json"},
//       body: jsonEncode(body),
//     );
//     return jsonDecode(response.body);
//   }

//   Future<dynamic> put(String endpoint, Map<String, dynamic> body) async {
//     final response = await http.put(
//       Uri.parse("$baseUrl$endpoint"),
//       headers: {"Content-Type": "application/json"},
//       body: jsonEncode(body),
//     );
//     return jsonDecode(response.body);
//   }

//   Future<dynamic> delete(String endpoint) async {
//     final response =
//         await http.delete(Uri.parse("$baseUrl$endpoint"));
//     return jsonDecode(response.body);
//   }
// }

// API FAKE PRA TESTE

class ApiService {
  // Dashboard
  Future<Map<String, dynamic>> getUser() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return {"nome": "Juliana", "email": "juliana@gmail.com"};
  }

  Future<Map<String, dynamic>> getSaldo() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return {"saldo": 3250.75};
  }

  Future<Map<String, dynamic>> getResumoMes() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return {"receitas": 4200.00, "despesas": 1800.50};
  }

  Future<List<Map<String, dynamic>>> getHistorico() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      {
        "titulo": "Mercado",
        "categoria": "Alimentação",
        "valor": 152.3,
        "data": "12/11/2025",
      },
      {
        "titulo": "Salário",
        "categoria": "Renda",
        "valor": 3200.0,
        "data": "10/11/2025",
      },
    ];
  }

  // Login
  Future<Map<String, dynamic>> login(String email, String senha) async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (email == "teste@teste.com" && senha == "12345678") {
      return {"success": true};
    } else {
      throw Exception("Usuário ou senha inválidos");
    }
  }

  // Register
  Future<Map<String, dynamic>> register(
    String nome,
    String email,
    String senha,
  ) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return {"success": true};
  }

  // MÉTODOS (POST / GET / ...)

  Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
    await Future.delayed(const Duration(milliseconds: 600));

    // Mock da rota de dicas
    if (endpoint == "/dicas") {
      return {"resposta": "Anotado! Vou te ajudar com isso"};
    }

    return {"ok": true};
  }

  Future<dynamic> get(String endpoint) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return {"message": "GET mock executado"};
  }

  Future<dynamic> put(String endpoint, Map<String, dynamic> body) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return {"message": "PUT mock executado"};
  }

  Future<dynamic> delete(String endpoint) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return {"message": "DELETE mock executado"};
  }
}
