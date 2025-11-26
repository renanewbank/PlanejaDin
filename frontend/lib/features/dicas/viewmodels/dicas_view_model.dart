// PlanejaDin-frontend/lib/features/dicas/viewmodels/dicas_view_model.dart
import 'package:flutter/material.dart';
import '../../../core/models/chat_message.dart';
import '../services/dicas_service.dart';

class DicasViewModel extends ChangeNotifier {
  final DicasService _service;

  DicasViewModel(this._service);

  List<ChatMessage> messages = [];
  bool loading = false;

  final ScrollController scrollController = ScrollController();

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    // Mensagem enviada pelo usuário
    messages.add(ChatMessage(text: text, sender: MessageSender.user));
    notifyListeners();
    _scrollToBottom();

    loading = true;
    notifyListeners();

    // Chamada da API
    final resposta = await _service.sendMessage(text);

    messages.add(ChatMessage(text: resposta, sender: MessageSender.din));

    loading = false;
    notifyListeners();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void clearMessages() {
    messages.clear();
    notifyListeners();
  }
}
