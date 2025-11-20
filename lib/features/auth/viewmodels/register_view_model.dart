import 'package:flutter/material.dart';
import '../../../services/api_service.dart';

class RegisterViewModel extends ChangeNotifier {
  final ApiService _api = ApiService();

  bool loading = false;
  String? errorMessage;

  bool nomeError = false;
  bool emailError = false;
  bool senhaError = false;
  bool confirmSenhaError = false;

  final RegExp _emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  void reset() {
    loading = false;
    errorMessage = null;
    nomeError = false;
    emailError = false;
    senhaError = false;
    confirmSenhaError = false;
    notifyListeners();
  }

  bool validate(String nome, String email, String senha, String confirmSenha) {
    nomeError = false;
    emailError = false;
    senhaError = false;
    confirmSenhaError = false;
    errorMessage = null;

    bool algumCampoVazio =
        nome.isEmpty || email.isEmpty || senha.isEmpty || confirmSenha.isEmpty;

    if (algumCampoVazio) {
      errorMessage = 'Preencha todos os campos!';
    }

    if (nome.isEmpty) nomeError = true;

    if (email.isEmpty || !_emailRegex.hasMatch(email)) {
      emailError = true;
      if (errorMessage == null) errorMessage = 'Email inválido';
    }

    if (senha.isEmpty || senha.length < 8) {
      senhaError = true;
      if (errorMessage == null)
        errorMessage = 'Senha deve ter ao menos 8 caracteres';
    }

    if (confirmSenha.isEmpty || confirmSenha != senha) {
      confirmSenhaError = true;
      if (errorMessage == null) errorMessage = 'As senhas não coincidem';
    }

    notifyListeners();
    return !(nomeError || emailError || senhaError || confirmSenhaError);
  }

  Future<bool> register(
    String nome,
    String email,
    String senha,
    String confirmSenha,
  ) async {
    final ok = validate(nome.trim(), email.trim(), senha, confirmSenha);
    if (!ok) return false;

    loading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final res = await _api.register(nome, email, senha);

      if (res is Map && (res['success'] == true || res['ok'] == true)) {
        loading = false;
        notifyListeners();
        return true;
      }

      loading = false;
      notifyListeners();
      return true;
    } catch (e) {
      errorMessage = e.toString();
      loading = false;
      notifyListeners();
      return false;
    }
  }
}
