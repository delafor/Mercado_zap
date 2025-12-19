import 'package:flutter/widgets.dart';
import 'package:mercado_zap/models/product.dart';

class ProductProvider with ChangeNotifier {
  final List<Product> _products = [];

  List<Product> get products => List.unmodifiable(_products);

  void adiconarProduto(Product product) {
    _products.add(product);
    notifyListeners();
  }

  void removerProduto(Product product) {
    _products.removeWhere((p) => p.id == product.id);
    notifyListeners();
  }

  Product? buscarProduto(String id) {
    try {
      _products.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  void limpar() {
    _products.clear();
    notifyListeners();
  }
}
