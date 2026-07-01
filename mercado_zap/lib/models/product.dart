class Product {
  final String id;

  final String name;
  String category;
  String description;
  String? urlImagem;
  String unidade;
  double price;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    this.urlImagem,
    required this.unidade,
    required this.price,
  });

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      category: map['category']?.toString() ?? '',
      description: map['description']?.toString() ?? '',
      urlImagem: map['urlImagem']?.toString(),
      unidade: map['unidade']?.toString() ?? '',
      price: (map['price'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'description': description,
      'urlImagem': urlImagem,
      'unidade': unidade,
      'price': price,
    };
  }
}
