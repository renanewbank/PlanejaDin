// lib/features/transaction/view/transaction_history_view.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../widgets/tips_badge.dart';
import '../viewmodels/transaction_history_view_model.dart';
import '../../../widgets/back_button_widget.dart';
import '../../../core/models/categoria.dart';
import '../../../widgets/bottom_nav_bar.dart';

class TransactionHistoryView extends StatelessWidget {
  const TransactionHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TransactionHistoryViewModel>();

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavBar(
        currentIndex: 2,
        onTap: (index) {
          if (index == 0) Navigator.pop(context);
        },
      ),
      body: vm.loading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(4, 30, 10, 20),
                      child: Row(
                        children: const [
                          BackButtonWidget(),
                          SizedBox(width: 12),
                          Text(
                            "Histórico de Transações",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Row(
                      children: [
                        _filterButton("Todas", true),
                        const SizedBox(width: 12),
                        _filterButton("Este mês", false),
                        const SizedBox(width: 12),
                        _filterButton("Filtrar", false),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Lista de transações
                    ...vm.transacoes.map((t) {
                      final tipo = parseCategoriaTipo(
                        t["categoria"].toString(),
                      );
                      final valor = ((t["valor"] as num?)?.toDouble() ?? 0.0);

                      return Container(
                        margin: const EdgeInsets.only(bottom: 14),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: tipo.color.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(tipo.icon, color: tipo.color),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    t["titulo"],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    tipo.label,
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "R\$ ${valor.toStringAsFixed(2)}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  t["data"],
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }),

                    const SizedBox(height: 20),

                    // Totais
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _rowValores(
                          "Receita",
                          "+ R\$ ${vm.receita.toStringAsFixed(2)}",
                          Colors.green,
                        ),
                        _rowValores(
                          "Despesa",
                          "- R\$ ${vm.despesa.toStringAsFixed(2)}",
                          Colors.red,
                        ),
                        _rowValores(
                          "Saldo",
                          "R\$ ${vm.saldo.toStringAsFixed(2)}",
                          Colors.black87,
                        ),
                        const SizedBox(height: 20),
                        Container(height: 1, color: Colors.black12),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Resumo por categoria
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: vm.resumoPorCategoria.entries.map((entry) {
                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(entry.key),
                                Text(
                                  "R\$ ${entry.value.toStringAsFixed(2)}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                          ],
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 100),
                  ],
                ),
                const Positioned(bottom: 20, right: 24, child: TipsBadge()),
              ],
            ),
    );
  }

  Widget _rowValores(String label, String valor, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Text(
          valor,
          style: TextStyle(fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }

  Widget _filterButton(String label, bool selected) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: selected ? Colors.green.shade100 : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.green : Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
