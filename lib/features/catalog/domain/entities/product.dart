class Product {
  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.price,
    required this.unit,
    this.imageUrl,
  });

  final String id;
  final String name;
  final String category;
  final String description;
  final double price;
  final String unit;
  final String? imageUrl;

  factory Product.fromMap(Map<String, dynamic> map) => Product(
        id: map['id']?.toString() ?? '',
        name: map['name']?.toString() ?? '',
        category: map['category']?.toString() ?? '',
        description: map['description']?.toString() ?? '',
        price: (map['price'] as num?)?.toDouble() ?? 0,
        unit: map['unidade']?.toString() ?? '',
        imageUrl: map['urlImagem']?.toString(),
      );
}
