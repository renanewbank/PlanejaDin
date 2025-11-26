import 'package:flutter/material.dart';
import '../../../services/api_service.dart';

class LoginViewModel extends ChangeNotifier {
  final ApiService api;

  LoginViewModel(this.api);

  bool loading = false;
  String? errorMessage;

  Future<bool> login(String email, String senha) async {
    loading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await api.login(email, senha); // preenche _userId dentro do ApiService
      loading = false;
      notifyListeners();
      return true;
    } catch (e) {
      loading = false;
      errorMessage = "Usuário ou senha inválidos";
      notifyListeners();
      return false;
    }
  }
}
