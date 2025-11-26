// lib/features/dicas/services/dicas_service.dart
import '../../../services/api_service.dart';

class DicasService {
  final ApiService api;

  DicasService(this.api);

  Future<String> sendMessage(String message) async {
    try {
      final response = await api.post('/chat/demo', {
        "message": message,
        "context": null,
      });

      return response["ai_response"] ??
          "Desculpe, não consegui entender a resposta da IA.";
    } catch (e) {
      return "Desculpe, não consegui entender. (erro 500)";
    }
  }
}
