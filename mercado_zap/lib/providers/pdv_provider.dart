import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:mercado_zap/models/pedido.dart';
import 'package:mercado_zap/providers/cart_provider.dart';

enum Vendastatus { nenhuma, aberta, fechada, cancelada, Finalizada }

class PdvProvider with ChangeNotifier {
  final CartProvider cart;
  PdvProvider({required this.cart});

  Vendastatus get status => _status;

  Vendastatus _status = Vendastatus.nenhuma;

  void abrirVenda() {
    // fazer a logica
    _status = Vendastatus.aberta;
    notifyListeners();
  }

  void cancelarVenda() {
    // fazer a logica
    _status = Vendastatus.cancelada;
    notifyListeners();
  }

  Future<void> finalizarVendar() async {
    final itens = cart.itens;
    final total = cart.total;
    if (itens.isEmpty) return;

    final id = DateTime.now().microsecondsSinceEpoch.toString();
    // formatar data
    // fazer a logica

    //gerar o pedido
    final pedido = Pedido(
      id: id,
      itens: itens,
      total: total,
      data: DateTime.now(),
    );
    //salvar no banco
    final box = Hive.box('mybox');
    await box.put(id, pedido.toMap());
// aqui vai ver salvando no bacno depois modelar conforeme preciso
    //gerar mensagem
  final msg = pedido.gerarMensagem();
    //limpar carrinho
      cart.limpar(); // vai ser dentro do cart_provider


    _status = Vendastatus.Finalizada;
    notifyListeners();
  }

  void limpar() {
    _status = Vendastatus.nenhuma;
    notifyListeners();
  }
}
