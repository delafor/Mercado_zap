import 'package:flutter/widgets.dart';
import 'package:mercado_zap/database/read_database.dart';
import 'package:mercado_zap/models/product.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _allproducts = [];
  List<Product> _products = [];

  List<Product> get products => List.unmodifiable(_products);

  void carregarProdutos() {
    final data = ReadDatabase().readProducts();
    notifyListeners();

    _allproducts = List.from(data);
    _products = List.from(data);
  }

  void adiconarProduto(Product product) {
    _products.add(product);
    _allproducts.add(product);
    notifyListeners();
  }

  void removerProduto(Product product) {
    _allproducts.removeWhere((p) => p.id == product.id);
    _products.removeWhere((p) => p.id == product.id);
    notifyListeners();
  }

  void buscarProduto(String query) {
    if (query.isEmpty) {
      _products = List.from(_allproducts);
    } else {
      _products = _allproducts
          .where(
            (element) =>
                element.name.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    }
    notifyListeners();
  }

  void limpar() {
    _products.clear();
    _allproducts.clear();
    notifyListeners();
  }
}
