import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:provider/provider.dart';
import 'package:teste/features/transaction/viewmodels/transaction_view_model.dart';
import '../../../core/models/categoria.dart';
import '../../../core/models/transaction.dart';
import '../../../widgets/back_button_widget.dart';
import '../../../widgets/primary_button.dart';
import '../../../widgets/input_field.dart';
import '../../../widgets/tips_badge.dart';
import '../../../widgets/bottom_nav_bar.dart';

class TransactionView extends StatelessWidget {
  TransactionView({super.key});

  final MoneyMaskedTextController valorController = MoneyMaskedTextController(
    leftSymbol: "R\$ ",
    decimalSeparator: ",",
    thousandSeparator: ".",
    precision: 2,
  );

  final TextEditingController descricaoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TransactionsViewModel>();

    // sincroniza controller com viewmodel
    valorController.afterChange = (prev, next) {
      vm.setValor(valorController.numberValue);
    };

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavBar(
        currentIndex: 0,
        onTap: (index) {
          if (index == 0) Navigator.pop(context);
        },
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 30, 24, 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      BackButtonWidget(),
                      SizedBox(width: 12),
                      Text(
                        "Registro de Transação",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Receita / Despesa
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () => vm.setType(TransactionType.receita),
                        child: Column(
                          children: [
                            Text(
                              "Receita",
                              style: TextStyle(
                                fontSize: 18,
                                color: vm.type == TransactionType.receita
                                    ? Colors.black
                                    : Colors.grey,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              height: 2,
                              width: 80,
                              color: vm.type == TransactionType.receita
                                  ? Colors.black
                                  : Colors.grey.shade300,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 40),
                      GestureDetector(
                        onTap: () => vm.setType(TransactionType.despesa),
                        child: Column(
                          children: [
                            Text(
                              "Despesa",
                              style: TextStyle(
                                fontSize: 18,
                                color: vm.type == TransactionType.despesa
                                    ? Colors.black
                                    : Colors.grey,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              height: 2,
                              width: 80,
                              color: vm.type == TransactionType.despesa
                                  ? Colors.black
                                  : Colors.grey.shade300,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  InputField(
                    hint: "Digite o valor",
                    controller: valorController,
                    keyboardType: TextInputType.number,
                    error: vm.submitTried && vm.valor <= 0,
                  ),

                  const SizedBox(height: 16),

                  // Categoria
                  DropdownButtonFormField<Categoria>(
                    value: vm.categoria,
                    onChanged: (value) => vm.setCategoria(value),
                    items: vm.categorias
                        .map(
                          (c) => DropdownMenuItem(
                            value: c,
                            child: Row(
                              children: [
                                Icon(
                                  c.tipo.icon,
                                  color: c.tipo.color,
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                Text(c.nome),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                    decoration: InputDecoration(
                      hintText: "Selecione a categoria",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),

                  const SizedBox(height: 6),
                  GestureDetector(
                    onTap: () {
                      // modal para criar categoria
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 6),
                      child: Text(
                        "+ Criar nova categoria",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.green.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Data
                  GestureDetector(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: vm.data,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) vm.setData(picked);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 18,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.grey.shade400),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${vm.data.day}/${vm.data.month}/${vm.data.year}",
                            style: const TextStyle(fontSize: 16),
                          ),
                          const Icon(Icons.calendar_today_outlined),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Descrição
                  InputField(
                    hint: "Descrição (opcional)",
                    controller: descricaoController,
                    onChanged: vm.setDescricao,
                    keyboardType: TextInputType.text,
                  ),

                  const SizedBox(height: 16),

                  // Método de pagamento
                  DropdownButtonFormField<String>(
                    value: vm.metodoPagamento,
                    items: const [
                      DropdownMenuItem(value: "Pix", child: Text("Pix")),
                      DropdownMenuItem(
                        value: "Crédito",
                        child: Text("Crédito"),
                      ),
                      DropdownMenuItem(value: "Débito", child: Text("Débito")),
                      DropdownMenuItem(
                        value: "Dinheiro",
                        child: Text("Dinheiro"),
                      ),
                    ],
                    onChanged: vm.setMetodoPagamento,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  vm.loading
                      ? const Center(
                          child: CircularProgressIndicator(color: Colors.green),
                        )
                      : PrimaryButton(
                          text: vm.type == TransactionType.receita
                              ? "Registrar Receita"
                              : "Registrar Despesa",
                          onPressed: () async {
                            final ok = await vm.submit();
                            if (ok && context.mounted) {
                              Navigator.pop(context);
                            }
                          },
                        ),

                  if (vm.errorMessage != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      vm.errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ],
                ],
              ),
            ),
            const Positioned(bottom: 20, right: 24, child: TipsBadge()),
          ],
        ),
      ),
    );
  }
}
