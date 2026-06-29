class Order {
  String id;
  List<Map<String, dynamic>> items; // lista de itens (CartItem.toMap())
  String status;
  double total;
  String date;

  Order({
    required this.id,
    required this.items,
    required this.status,
    required this.total,
    required this.date,
  });
  Order.fromMap(Map<String, dynamic> map)
    : id = map['id'],
      items = map['items'],
      status = map['status'],
      total = map['total'],
      date = map['date'];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'items': items,
      'status': status,
      'total': total,
      'date': date,
    };
  }
}
