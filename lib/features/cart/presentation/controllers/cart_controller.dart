import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

import '../../../../app/core/storage/hive_boxes.dart';
import '../../../catalog/domain/entities/product.dart';
import '../../data/datasources/cart_local_datasource.dart';
import '../../data/repositories/cart_repository_impl.dart';
import '../../domain/entities/cart_item.dart';

class CartController extends ChangeNotifier {
  CartController() : _repository = CartRepositoryImpl(CartLocalDataSource(Hive.box(HiveBoxes.app)));

  final CartRepositoryImpl _repository;
  List<CartItem> _items = [];
  bool isLoading = false;

  List<CartItem> get items => List.unmodifiable(_items);
  int get totalQuantity => _items.fold(0, (sum, item) => sum + item.quantity);
  double get total => _items.fold(0, (sum, item) => sum + item.price * item.quantity);

  Future<void> load() async {
    isLoading = true;
    notifyListeners();
    _items = await _repository.getItems();
    isLoading = false;
    notifyListeners();
  }

  Future<void> addProduct(Product product) async {
    final index = _items.indexWhere((item) => item.productId == product.id);
    if (index == -1) {
      _items.add(CartItem.fromProduct(product));
    } else {
      _items[index].quantity++;
    }
    await _persist();
  }

  Future<void> increment(CartItem item) async {
    item.quantity++;
    await _persist();
  }

  Future<void> decrement(CartItem item) async {
    if (item.quantity > 1) {
      item.quantity--;
    } else {
      _items.remove(item);
    }
    await _persist();
  }

  Future<void> remove(CartItem item) async {
    _items.removeWhere((value) => value.productId == item.productId);
    await _persist();
  }

  Future<void> clear() async {
    _items.clear();
    await _persist();
  }

  Future<void> _persist() async {
    await _repository.saveItems(_items);
    notifyListeners();
  }
}
