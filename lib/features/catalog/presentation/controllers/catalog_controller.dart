import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

import '../../../app/core/storage/hive_boxes.dart';
import '../../catalog/data/datasources/product_local_datasource.dart';
import '../../catalog/data/repositories/product_repository_impl.dart';
import '../../catalog/domain/entities/product.dart';

class CatalogController extends ChangeNotifier {
  CatalogController()
      : _repository = ProductRepositoryImpl(
          ProductLocalDataSource(Hive.box(HiveBoxes.app)),
        );

  final ProductRepositoryImpl _repository;

  List<Product> _allProducts = const [];
  List<Product> _products = const [];
  String _query = '';
  String _category = 'Todos';
  bool isLoading = false;
  String? error;

  List<Product> get products => List.unmodifiable(_products);
  String get category => _category;

  List<String> get categories {
    final values = _allProducts.map((product) => product.category).where((value) => value.isNotEmpty).toSet().toList()..sort();
    return ['Todos', ...values];
  }

  Future<void> load() async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      _allProducts = await _repository.getProducts();
      _applyFilters();
    } catch (e) {
      error = 'Não foi possível carregar os produtos.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void search(String value) {
    _query = value.trim().toLowerCase();
    _applyFilters();
    notifyListeners();
  }

  void selectCategory(String value) {
    _category = value;
    _applyFilters();
    notifyListeners();
  }

  void _applyFilters() {
    _products = _allProducts.where((product) {
      final matchesCategory = _category == 'Todos' || product.category == _category;
      final matchesQuery = _query.isEmpty || product.name.toLowerCase().contains(_query) || product.category.toLowerCase().contains(_query);
      return matchesCategory && matchesQuery;
    }).toList(growable: false);
  }
}
