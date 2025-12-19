import 'package:flutter/foundation.dart';
import 'package:mercado_zap/models/cart_item.dart';

class CartProvider with ChangeNotifier {
  //cria o providedr e notifica a interface quando o carrinho mudar algo
  final List<CartItem> _itens =
      []; //Lista privada dos itens,ngm fora do providedr pode mexer direto nela

  List<CartItem> get itens => List.unmodifiable(
    _itens,
  ); // retorna os itens do carrinho somente para leitura

  double get total =>
      _itens.fold(0, (soma, item) => soma + (item.price * item.quantity));

  //Metodos opcionais
  //AdicionarItem - RemoverItem
  void adicionarItem(CartItem item) {
    // verificar se a o item no carrinho para ai sim poder adicionalo, caso ja tenha o item,aumenta a quantidade do item
    final index = _itens.indexWhere((i) => i.productId == item.productId);

    if (index >= 0) {
      _itens[index].quantity++;
    } else {
      _itens.add(item);
    }
    notifyListeners();
  }
  //remover item(unidade)

  void removerItem(CartItem item) {
    // verificar se a o item no carrinho para ai sim poder removelo
    final index = _itens.indexWhere((i) => i.productId == item.productId);
    if (index < -1) return;

    if (_itens[index].quantity > 1) {
      _itens[index].quantity--;
    } else {
      _itens.removeAt(index);
    }

    notifyListeners();
  }

  //RemoverItemCompleto - remove todos os itens de uma vez do carrinho
  void removerItemCompleto(CartItem item) {
    _itens.removeWhere((i) => i.productId == item.productId);
    notifyListeners();
  }
  //Calcular quantidaded total de itens no carrinho

  void limpar() {
    _itens.clear();
    notifyListeners();
  }
}
