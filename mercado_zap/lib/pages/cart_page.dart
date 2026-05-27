import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mercado_zap/Payments/checkout_payment_page.dart';
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

                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,

                      // exibe o nome do produto
                    ),

                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          Text(
                            item.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            'R\$ ${(item.price * item.quantity).toStringAsFixed(2)}',
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(16),

        child: SizedBox(
          width: double.infinity,
          height: 50,

          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CheckoutPaymentPage(total: cart.total),
                ),
              );
            },

            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),

            child: const Text(
              'Finalizar Compra',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}

//opcao de aumentar quantidade de produtos + remover produtos do carrinho
// finalizar comprar +  gerar pagamento,gera pedido => enviar pedido para o whatzap
