import 'package:mercado_zap/models/cart_item.dart';

class Pedido {
  final String id;
  final List<CartItem> itens;
  final double total;
  final DateTime data;

  Pedido({
    required this.id,
    required this.itens,
    required this.total,
    required this.data,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'total': total,
      'data': data,
      'itens': itens.map((i) => i.toMap()).toList(),
    };
  }

  String gerarMensagem() {
    final buffer = StringBuffer();
    // Cria um StringBuffer, que é mais eficiente que concatenar strings com +
    // Ele permite montar o texto aos poucos
    buffer.writeln('🧾 Pedido $id'); // Adiciona o título do pedido com o ID

    for (final item in itens) {
      buffer.writeln(
        '${item.name},${item.quantity},${item.price}, ${item.quantity * item.price} ',
      );
    }
    ;
    // Linha em branco antes do total
    buffer.writeln('');
    // Adiciona o valor total do pedido formatado com duas casas decimais
    buffer.writeln('Total: $total');
    // Converte tudo que foi escrito no buffer para String
    // e retorna a mensagem final
    return buffer.toString();
  }

  static fromMap(e) {}
}
