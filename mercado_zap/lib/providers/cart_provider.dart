import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:mercado_zap/models/cart_item.dart';

class CartProvider with ChangeNotifier {
  final Box _box = Hive.box('appBox');

  final List<CartItem> _itens = [];

  List<CartItem> get itens => List.unmodifiable(_itens);

  double get total =>
      _itens.fold(0, (soma, item) => soma + (item.price * item.quantity));

  // ← CHAME ISSO NO INICIO DO APP
  Future<void> carregarCarrinho() async {
    final data = _box.get('carrinho', defaultValue: []);
    _itens.clear();
    _itens.addAll(
      (data as List).map((e) => CartItem.formMap(Map<String, dynamic>.from(e))),
    );
    notifyListeners();
  }

  int get quantidadeTotal {
    return _itens.fold(
      0,
      (soma, item) => soma + item.quantity,
    ); // eplicar melhhor
  }

  // ← SALVA NO HIVE SEMPRE QUE MUDAR
  void _salvar() {
    _box.put('carrinho', _itens.map((e) => e.toMap()).toList());
  }

  void adicionarItem(CartItem item) {
    final index = _itens.indexWhere(
      (i) => i.productId == item.productId,
    ); //aqqui preciso passar a quantidade do contador la,pra marcar qquantos produtos vai pro carrinho
    if (index >= 0) {
      _itens[index].quantity += item.quantity;
    } else {
      _itens.add(item);
    }
    _salvar(); // ← persiste
    notifyListeners();
  }

  void removerItem(CartItem item) {
    final index = _itens.indexWhere((i) => i.productId == item.productId);
    if (index < 0) return;
    if (_itens[index].quantity > 1) {
      _itens[index].quantity--;
    } else {
      _itens.removeAt(index);
    }
    _salvar(); // ← persiste
    notifyListeners();
  }

  void limpar() {
    _itens.clear();
    _salvar(); // ← persiste
    notifyListeners();
  }
}
