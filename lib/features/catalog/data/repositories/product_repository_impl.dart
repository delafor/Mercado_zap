import '../../catalog/domain/entities/product.dart';
import '../../catalog/domain/repositories/product_repository.dart';
import '../datasources/product_local_datasource.dart';

class ProductRepositoryImpl implements ProductRepository {
  ProductRepositoryImpl(this._localDataSource);

  final ProductLocalDataSource _localDataSource;

  @override
  Future<List<Product>> getProducts() async => _localDataSource.getProducts();
}
