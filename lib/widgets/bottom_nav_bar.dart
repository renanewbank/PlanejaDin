import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
      onTap: onTap,
      backgroundColor: const Color(0xff2F7A52),
      elevation: 8,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white70,
      showUnselectedLabels: true,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "início"),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: "pesquisar"),
        BottomNavigationBarItem(icon: Icon(Icons.list), label: "transações"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "meu perfil"),
      ],
    );
  }
}
