import 'package:flutter/widgets.dart';
import 'package:mercado_zap/database/read_database.dart';
import 'package:mercado_zap/models/product.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _allproducts = [];
  List<Product> _products = [];
  String _selectedCategory = 'Todos';

  String get selectedCategory => _selectedCategory;

  List<Product> get products => List.unmodifiable(_products);

  void selecionarCategoria(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  List<Product> get productsFiltrados {
    if (_selectedCategory == 'Todos') {
      return _products;
    }

    return _products.where((produto) {
      return produto.category == _selectedCategory;
    }).toList();
  }

  void carregarProdutos() async {
    final data = ReadDatabase().readProducts();

    for (var p in data) {
      print('PRODUTO: ${p.name} | IMAGEM: ${p.urlImagem}');
    }

    _allproducts = List.from(data);
    _products = List.from(data);
    notifyListeners();
  }

  void adiconarProduto(Product product) async {
    _products.add(product);
    _allproducts.add(product);
    notifyListeners();
  }

  void removerProduto(Product product) async {
    _allproducts.removeWhere((p) => p.id == product.id);
    _products.removeWhere((p) => p.id == product.id);
    notifyListeners();
  }

  void buscarProduto(String query) async {
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
