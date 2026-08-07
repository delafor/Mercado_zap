import 'package:hive/hive.dart';

import '../../../../app/core/storage/hive_boxes.dart';
import '../../domain/entities/cart_item.dart';

class CartLocalDataSource {
  CartLocalDataSource(this._box);

  final Box _box;

  List<CartItem> getItems() {
    final raw = _box.get(HiveKeys.cart, defaultValue: const <dynamic>[]);
    if (raw is! List) return const [];
    return raw.whereType<Map>().map((item) => CartItem.fromMap(Map<String, dynamic>.from(item))).toList();
  }

  Future<void> saveItems(List<CartItem> items) => _box.put(HiveKeys.cart, items.map((item) => item.toMap()).toList());
}
