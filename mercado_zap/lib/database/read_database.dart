// agora ler
import 'package:hive/hive.dart';
import 'package:mercado_zap/models/pedido.dart';
import 'package:mercado_zap/models/product.dart';

class ReadDatabase {
  final Box box = Hive.box('appBox');

  List<Product> readProducts() {
    final List data = box.get('products', defaultValue: []);

    return data.map((e) {
      final Map<String, dynamic> map = Map<String, dynamic>.from(e as Map);
      return Product.fromMap(map);
    }).toList();
  }
}
