import 'package:flutter/material.dart';
import '../../../services/api_service.dart';

class LoginViewModel extends ChangeNotifier {
  final ApiService api = ApiService();

  bool carregando = false;
  bool loginInvalido = false;
  String? errorMessage;
  Map<String, dynamic>? usuario;

  Future<bool> login(String email, String senha) async {
    carregando = true;
    loginInvalido = false;
    errorMessage = null;
    notifyListeners();

    try {
      final result = await api.login(email, senha);

      if (result == null || result["success"] == false) {
        loginInvalido = true;
        errorMessage = "E-mail ou senha incorretos";
        return false;
      }

      usuario = result;
      return true;
    } catch (e) {
      loginInvalido = true;
      errorMessage = "E-mail ou senha incorretos";
      return false;
    } finally {
      carregando = false;
      notifyListeners();
    }
  }
}
