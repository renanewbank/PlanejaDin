import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teste/features/transaction/view/transaction_history_view.dart';
import 'package:teste/features/transaction/view/transaction_view.dart';
import '../../../widgets/bottom_nav_bar.dart';
import '../../../widgets/tips_badge.dart';
import '../../../core/models/categoria.dart';
import '../viewmodels/dashboard_view_model.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vm = context.read<DashboardViewModel>();
      vm.carregarDados(); // aqui pode dar notifyListeners à vontade
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<DashboardViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavBar(
        currentIndex: 0,
        onTap: (index) {
          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const TransactionHistoryView()),
            );
          }
        },
      ),
      body: SafeArea(
        child: vm.loading
            ? const Center(child: CircularProgressIndicator())
            : Stack(
                children: [
                  SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 30),
                        Center(
                          child: Text(
                            "Olá, ${vm.nomeUsuario}",
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildSaldo(vm),
                        const SizedBox(height: 20),
                        _buildResumoMes(vm),
                        const SizedBox(height: 20),
                        _buildAcoes(),
                        const SizedBox(height: 20),
                        _buildHistorico(vm),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                  const Positioned(bottom: 20, right: 24, child: TipsBadge()),
                ],
              ),
      ),
    );
  }

  Widget _buildSaldo(DashboardViewModel vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Saldo atual",
          style: TextStyle(fontSize: 16, color: Colors.black87),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Text(
              vm.saldoVisivel ? "R\$ ${vm.saldo.toStringAsFixed(2)}" : "••••••",
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w700),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: vm.toggleSaldo,
              child: Icon(
                vm.saldoVisivel ? Icons.visibility : Icons.visibility_off,
                size: 22,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildResumoMes(DashboardViewModel vm) {
    double total = vm.receitaMes + vm.despesaMes;
    double percent = total == 0 ? 0.0 : vm.receitaMes / total;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(offset: Offset(0, 2), blurRadius: 5, color: Colors.black12),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Resumo do mês",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 18),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: percent,
              minHeight: 12,
              backgroundColor: Colors.purple.shade100,
              valueColor: AlwaysStoppedAnimation(Colors.green),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // RECEITAS (ESQUERDA)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 6,
                        backgroundColor: Colors.green,
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        "Receitas",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "R\$ ${vm.receitaMes.toStringAsFixed(2)}",
                    style: const TextStyle(fontSize: 15),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 6,
                        backgroundColor: Colors.purple,
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        "Despesas",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "R\$ ${vm.despesaMes.toStringAsFixed(2)}",
                    style: const TextStyle(fontSize: 15),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAcoes() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _acaoButton(
          icon: Icons.add_circle_outline,
          label: "Adicionar\nTransação",
          color: Colors.green,
          onTap: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => TransactionView()),
            );
            if (result == true) {
              final vm = context.read<DashboardViewModel>();
              vm.carregarDados();
            }
          },
        ),
        _acaoButton(
          icon: Icons.flag_outlined,
          label: "Criar nova\nMeta",
          color: const Color(0xff6A0DAD),
          onTap: () {
            // futura tela de meta
          },
        ),
      ],
    );
  }

  Widget _acaoButton({
    required IconData icon,
    required String label,
    required Color color,
    VoidCallback? onTap,
  }) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: 1,
            backgroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          onPressed: onTap,
          child: Column(
            children: [
              Icon(icon, color: color, size: 26),
              const SizedBox(height: 6),
              Text(label, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHistorico(DashboardViewModel vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const TransactionHistoryView()),
            );
          },
          child: Row(
            children: const [
              Text(
                "Histórico recente",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              SizedBox(width: 4),
              Icon(
                Icons.arrow_forward_ios,
                size: 18,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Column(
          children: vm.historico
              .map((item) => _buildHistoricoItem(item))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildHistoricoItem(dynamic item) {
    final tipo = parseCategoriaTipo(item["categoria"]?.toString() ?? "");

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: tipo.color.withOpacity(0.2),
            child: Icon(tipo.icon, color: tipo.color),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item["titulo"],
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(tipo.label, style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "R\$ ${(item["valor"] is double) ? (item["valor"] as double).toStringAsFixed(2) : item["valor"].toString()}",
                style: TextStyle(
                  color: tipo == CategoriaTipo.salario
                      ? Colors.green
                      : Colors.red,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(item["data"], style: const TextStyle(color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }
}
