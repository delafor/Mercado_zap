import '../../domain/entities/cart_item.dart';
import '../../domain/repositories/cart_repository.dart';
import '../datasources/cart_local_datasource.dart';

class CartRepositoryImpl implements CartRepository {
  CartRepositoryImpl(this._local);

  final CartLocalDataSource _local;

  @override
  Future<List<CartItem>> getItems() async => _local.getItems();

  @override
  Future<void> saveItems(List<CartItem> items) => _local.saveItems(items);
}
