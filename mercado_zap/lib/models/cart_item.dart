import 'package:mercado_zap/models/product.dart';

class CartItem {
  String id;
  String productId;
  String name;
  int quantity;
  double price;

  CartItem({
    required this.id,
    required this.productId,
    required this.name,
    required this.quantity,
    required this.price,
  });

  // ← ADICIONE ISSO
  factory CartItem.fromProduct(Product product, {int quantity = 1}) {
    return CartItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(), // gera um id único
      productId: product.id,
      name: product.name,
      price: product.price,
      quantity: quantity,
    );
  }

  CartItem.formMap(Map<String, dynamic> map)
    : id = map['id'],
      productId = map['productId'],
      name = map['name'],
      quantity = map['quantity'],
      price = map['price'];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productId': productId,
      'name': name,
      'quantity': quantity,
      'price': price,
    };
  }
}
