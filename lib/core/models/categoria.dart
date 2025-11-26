import 'package:flutter/material.dart';

// CLASSE PRINCIPAL — usada pela API
class Categoria {
  final int id;
  final String nome;

  Categoria({required this.id, required this.nome});

  factory Categoria.fromJson(Map<String, dynamic> json) {
    return Categoria(id: json["id"], nome: json["nome"]);
  }

  // Conecta a categoria real ao enum visual
  CategoriaTipo get tipo => parseCategoriaTipo(nome);
}

// ENUM — usado para ícone, cor e label no layout
enum CategoriaTipo { mercado, salario, transporte, lazer, outro }

// Converte nome recebido da API para o Enum visual
CategoriaTipo parseCategoriaTipo(String nome) {
  switch (nome.toLowerCase()) {
    case "mercado":
    case "alimentação":
    case "alimentacao":
      return CategoriaTipo.mercado;

    case "salário":
    case "salario":
    case "renda":
      return CategoriaTipo.salario;

    case "transporte":
    case "uber":
    case "ônibus":
    case "onibus":
      return CategoriaTipo.transporte;

    case "lazer":
    case "entretenimento":
      return CategoriaTipo.lazer;

    default:
      return CategoriaTipo.outro;
  }
}

// EXTENSION — fornece ícone, cor e nome formatado
extension CategoriaTipoData on CategoriaTipo {
  IconData get icon {
    switch (this) {
      case CategoriaTipo.mercado:
        return Icons.shopping_cart;
      case CategoriaTipo.salario:
        return Icons.attach_money;
      case CategoriaTipo.transporte:
        return Icons.directions_car;
      case CategoriaTipo.lazer:
        return Icons.local_activity;
      default:
        return Icons.receipt_long;
    }
  }

  Color get color {
    switch (this) {
      case CategoriaTipo.salario:
        return Colors.green;
      case CategoriaTipo.transporte:
        return Colors.blue;
      case CategoriaTipo.lazer:
        return Colors.purple;
      case CategoriaTipo.mercado:
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String get label {
    switch (this) {
      case CategoriaTipo.mercado:
        return "Mercado";
      case CategoriaTipo.salario:
        return "Salário";
      case CategoriaTipo.transporte:
        return "Transporte";
      case CategoriaTipo.lazer:
        return "Lazer";
      default:
        return "Outro";
    }
  }
}
