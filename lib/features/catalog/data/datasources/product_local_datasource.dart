import 'package:hive/hive.dart';

import '../../../app/core/storage/hive_boxes.dart';
import '../../catalog/domain/entities/product.dart';

class ProductLocalDataSource {
  ProductLocalDataSource(this._box);

  final Box _box;

  List<Product> getProducts() {
    final raw = _box.get(HiveKeys.products, defaultValue: const <dynamic>[]);
    if (raw is! List) return const [];

    return raw
        .whereType<Map>()
        .map((item) => Product.fromMap(Map<String, dynamic>.from(item)))
        .where((product) => product.id.isNotEmpty)
        .toList(growable: false);
  }
}
