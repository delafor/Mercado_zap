

class Category {
  final int id;
  final String name;

  Category({required this.id, required this.name});

  Category.fromMap(Map<String, dynamic> map)
    : id = map['id'],
      name = map['name'];

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name};
  }
}
