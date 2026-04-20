import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mercado_zap/providers/cart_provider.dart';
import 'package:provider/provider.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    // context.watch fica "escutando" o CartProvider
    // toda vez que notifyListeners() for chamado, a tela reconstrói automaticamente
    final cart = context.watch<CartProvider>();

    return Scaffold(
      body:
          // cart.itens é a lista de itens do carrinho
          // .isEmpty verifica se a lista está vazia
          // se vazia, mostra mensagem, senão mostra a lista
          cart.itens.isEmpty
          ? Center(child: Text('Carrinho vazio'))
          : ListView.builder(
              // cart.itens.length define quantos itens o ListView vai renderizar
              itemCount: cart.itens.length,
              itemBuilder: (context, index) {
                // busca o item da posição atual da lista
                final item = cart.itens[index];

                return ListTile(
                  // exibe o nome do produto
                  title: Text(item.name),

                  // exibe a quantidade atual desse item no carrinho
                  subtitle: Text('Qtd: ${item.quantity}'),

                  // multiplica preço × quantidade para mostrar o subtotal do item
                  trailing: Text(
                    'R\$ ${(item.price * item.quantity).toStringAsFixed(2)}',
                  ),
                );
              },
            ),

      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          // cart.total é um getter do CartProvider que soma tudo automaticamente:
          // _itens.fold(0, (soma, item) => soma + (item.price * item.quantity))
          'Total: R\$ ${cart.total.toStringAsFixed(2)}',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

//opcao de aumentar quantidade de produtos + remover produtos do carrinho
// finalizar comprar +  gerar pagamento,gera pedido => enviar pedido para o whatzap
