enum TransactionType { receita, despesa }

class Transacao {
  final int? id;
  final TransactionType tipo;
  final double valor;
  final String? descricao;
  final int categoriaId;
  final DateTime data;
  final String metodoPagamento;

  Transacao({
    this.id,
    required this.tipo,
    required this.valor,
    this.descricao,
    required this.categoriaId,
    required this.data,
    required this.metodoPagamento,
  });

  Map<String, dynamic> toJson() {
    return {
      'tipo': tipo == TransactionType.receita ? 'receita' : 'despesa',
      'valor': valor,
      'descricao': descricao,
      'categoria_id': categoriaId,
      'data': data.toIso8601String(),
      'metodo_pagamento': metodoPagamento,
    };
  }

  factory Transacao.fromJson(Map<String, dynamic> json) {
    return Transacao(
      id: json['id'],
      tipo: json['tipo'] == 'receita'
          ? TransactionType.receita
          : TransactionType.despesa,
      valor: json['valor'].toDouble(),
      descricao: json['descricao'],
      categoriaId: json['categoria_id'],
      data: DateTime.parse(json['data']),
      metodoPagamento: json['metodo_pagamento'],
    );
  }
}
