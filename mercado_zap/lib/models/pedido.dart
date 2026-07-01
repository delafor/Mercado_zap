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

    buffer.writeln('🧾 Pedido $id');

    for (final item in itens) {
      buffer.writeln(
        '${item.name},${item.quantity},${item.price}, ${item.quantity * item.price} ',
      );
    }
    ;

    buffer.writeln('');

    buffer.writeln('Total: $total');

    return buffer.toString();
  }

  static fromMap(e) {}
}
