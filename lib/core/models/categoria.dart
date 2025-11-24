import 'package:flutter/material.dart';

enum Categoria { mercado, salario, transporte, lazer, outro }

extension CategoriaData on Categoria {
  IconData get icon {
    switch (this) {
      case Categoria.mercado:
        return Icons.shopping_cart;
      case Categoria.salario:
        return Icons.attach_money;
      case Categoria.transporte:
        return Icons.directions_car;
      case Categoria.lazer:
        return Icons.local_activity;
      default:
        return Icons.receipt_long;
    }
  }

  Color get color {
    switch (this) {
      case Categoria.salario:
        return Colors.green;
      case Categoria.transporte:
        return Colors.blue;
      case Categoria.lazer:
        return Colors.purple;
      case Categoria.mercado:
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String get label {
    switch (this) {
      case Categoria.mercado:
        return "Mercado";
      case Categoria.salario:
        return "Salário";
      case Categoria.transporte:
        return "Transporte";
      case Categoria.lazer:
        return "Lazer";
      default:
        return "Outro";
    }
  }
}

Categoria parseCategoria(String value) {
  switch (value.toLowerCase()) {
    case "mercado":
    case "alimentação":
    case "alimentacao":
      return Categoria.mercado;

    case "salário":
    case "salario":
    case "renda":
      return Categoria.salario;

    case "transporte":
    case "uber":
    case "ônibus":
      return Categoria.transporte;

    case "lazer":
    case "entretenimento":
      return Categoria.lazer;

    default:
      return Categoria.outro;
  }
}
