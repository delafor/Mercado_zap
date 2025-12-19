class Product {
  String id;
  String name;
  String category;
  String description;
  String? urlImagem;
  String unidade;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    this.urlImagem,
    required this.unidade,
  });
  Product.fromMap(Map<String, dynamic> map)
    : id = map['id'],
      name = map['name'],
      category = map['category'],
      description = map['description'],
      urlImagem = map['urlImagem'],
      unidade = map['unidade'];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'description': description,
      'urlImagem': urlImagem,
      'unidade': unidade,
    };
  }
}
