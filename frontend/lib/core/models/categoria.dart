// lib/core/models/categoria.dart
import 'package:flutter/material.dart';

enum CategoriaTipo { salario, mercado, transporte, lazer, outro }

extension CategoriaTipoExt on CategoriaTipo {
  String get label {
    switch (this) {
      case CategoriaTipo.salario:
        return "Renda";
      case CategoriaTipo.mercado:
        return "Alimentação";
      case CategoriaTipo.transporte:
        return "Transporte";
      case CategoriaTipo.lazer:
        return "Lazer";
      case CategoriaTipo.outro:
        return "Outro";
    }
  }

  IconData get icon {
    switch (this) {
      case CategoriaTipo.salario:
        return Icons.attach_money;
      case CategoriaTipo.mercado:
        return Icons.shopping_cart_outlined;
      case CategoriaTipo.transporte:
        return Icons.directions_bus;
      case CategoriaTipo.lazer:
        return Icons.local_bar;
      case CategoriaTipo.outro:
        return Icons.category_outlined;
    }
  }

  Color get color {
    switch (this) {
      case CategoriaTipo.salario:
        return Colors.green;
      case CategoriaTipo.mercado:
        return Colors.orange;
      case CategoriaTipo.transporte:
        return Colors.blue;
      case CategoriaTipo.lazer:
        return Colors.purple;
      case CategoriaTipo.outro:
        return Colors.grey;
    }
  }
}

/// Converte um texto vindo do backend ("Renda", "Alimentação"...)
/// para um enum CategoriaTipo.
CategoriaTipo parseCategoriaTipo(String value) {
  final v = value.toLowerCase();

  if (v.contains('sal') || v.contains('renda')) {
    return CategoriaTipo.salario;
  }
  if (v.contains('merc') || v.contains('alim')) {
    return CategoriaTipo.mercado;
  }
  if (v.contains('trans')) {
    return CategoriaTipo.transporte;
  }
  if (v.contains('lazer')) {
    return CategoriaTipo.lazer;
  }
  return CategoriaTipo.outro;
}

class Categoria {
  final String id;
  final String nome;
  final CategoriaTipo tipo;

  Categoria({required this.id, required this.nome, required this.tipo});

  factory Categoria.fromJson(Map<String, dynamic> json) {
    final nome = (json["name"] ?? json["nome"] ?? "").toString();
    return Categoria(
      id: json["id"].toString(),
      nome: nome,
      tipo: parseCategoriaTipo(nome),
    );
  }
}
