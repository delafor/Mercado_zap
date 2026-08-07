import '../../catalog/domain/entities/product.dart';

class CartItem {
  CartItem({required this.id, required this.productId, required this.name, required this.quantity, required this.price, this.imageUrl});

  final String id;
  final String productId;
  final String name;
  int quantity;
  final double price;
  final String? imageUrl;

  factory CartItem.fromProduct(Product product) => CartItem(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        productId: product.id,
        name: product.name,
        quantity: 1,
        price: product.price,
        imageUrl: product.imageUrl,
      );

  factory CartItem.fromMap(Map<String, dynamic> map) => CartItem(
        id: map['id']?.toString() ?? '',
        productId: map['productId']?.toString() ?? '',
        name: map['name']?.toString() ?? '',
        quantity: (map['quantity'] as num?)?.toInt() ?? 1,
        price: (map['price'] as num?)?.toDouble() ?? 0,
        imageUrl: map['urlImagem']?.toString(),
      );

  Map<String, dynamic> toMap() => {'id': id, 'productId': productId, 'name': name, 'quantity': quantity, 'price': price, 'urlImagem': imageUrl};
}
