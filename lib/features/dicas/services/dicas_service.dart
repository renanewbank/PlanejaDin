import '../../../services/api_service.dart';

class DicasService {
  final ApiService api = ApiService();

  Future<String> sendMessage(String message) async {
    final response = await api.post('/dicas', {"mensagem": message});

    return response["resposta"] ?? "Desculpe, não consegui entender.";
  }
}
