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
