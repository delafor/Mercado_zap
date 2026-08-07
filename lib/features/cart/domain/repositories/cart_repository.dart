import '../entities/cart_item.dart';

abstract interface class CartRepository {
  Future<List<CartItem>> getItems();
  Future<void> saveItems(List<CartItem> items);
}
