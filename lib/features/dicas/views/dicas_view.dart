import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/models/chat_message.dart';
import '../viewmodels/dicas_view_model.dart';
import '../../../widgets/back_button_widget.dart';

class DicasView extends StatefulWidget {
  const DicasView({super.key});

  @override
  State<DicasView> createState() => _DicasViewState();
}

class _DicasViewState extends State<DicasView> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();

    // Limpa as mensagens ao entrar na página
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vm = context.read<DicasViewModel>();
      vm.clearMessages();
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DicasViewModel>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // HEADER
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 40, 20, 10),
            child: Row(
              children: const [
                BackButtonWidget(),
                SizedBox(width: 12),
                Text(
                  "Dicas com a Din",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),

          // LISTA DE MENSAGENS
          Expanded(
            child: ListView.builder(
              controller: vm.scrollController,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              itemCount: vm.messages.length,
              itemBuilder: (context, index) {
                final msg = vm.messages[index];
                final isUser = msg.sender == MessageSender.user;

                return Align(
                  alignment: isUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      color: isUser
                          ? const Color(0xff6A2A82)
                          : const Color(0xff2F7A52),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      msg.text,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                );
              },
            ),
          ),

          if (vm.loading)
            const Padding(
              padding: EdgeInsets.all(12.0),
              child: CircularProgressIndicator(color: Color(0xff2F7A52)),
            ),

          // CAMPO DE TEXTO
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: "Digite sua pergunta...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  icon: const Icon(Icons.send, color: Color(0xff2F7A52)),
                  onPressed: () {
                    vm.sendMessage(controller.text);
                    controller.clear();
                  },
                ),
              ],
            ),
          ),

          // SUGESTÕES
          Padding(
            padding: const EdgeInsets.only(bottom: 10, top: 6),
            child: SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                children: [
                  _suggest("Me dê dicas de economia", vm),
                  _suggest("Como estão as minhas metas?", vm),
                  _suggest("Qual o vencimento ideal?", vm),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _suggest(String text, DicasViewModel vm) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: () => vm.sendMessage(text),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xffEDEAF4),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            text,
            style: const TextStyle(
              color: Color(0xff6A2A82),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
