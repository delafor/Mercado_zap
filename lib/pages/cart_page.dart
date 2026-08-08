import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'package:mercado_zap/Payments/checkout_payment_page.dart';

import 'package:mercado_zap/pages/adress_page.dart';

import 'package:mercado_zap/providers/cart_provider.dart';

import 'package:mercado_zap/widgets/counter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  int quantity = 1;

  void increase() {
    setState(() {
      quantity++;
    });
  }

  void decrease() {
    if (quantity > 1) {
      setState(() {
        quantity--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    // context.watch fica "escutando" o CartProvider
    // toda vez que notifyListeners() for chamado, a tela reconstrói automaticamente
    final cart = context.watch<CartProvider>();

    return Scaffold(
      appBar: AppBar(
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back),
        //   onPressed: () => Navigator.pop(context),
        // ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Meu carrinho',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              '${cart.totalItens} itens',
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
        actions: [
          if (cart.itens.isNotEmpty)
            IconButton(
              icon: SvgPicture.asset(
                'assets/Icons/lixeira.svg',
                width: 24,
                height: 24,
              ),
              onPressed: () {
                cart.limpar();
              },
            ),
        ],
      ),
      body:
          // cart.itens é a lista de itens do carrinho
          // .isEmpty verifica se a lista está vazia
          // se vazia, mostra mensagem, senão mostra a lista
          cart.itens.isEmpty
              ? Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    Image.asset(
                      'assets/Icons/cartIcon2.png',
                      width: 80,
                      height: 80,
                      errorBuilder: (context, error, stackTrace) {
                        return Text('Erro: $error');
                      },
                    ),
                    const SizedBox(width: 8),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Seu carrinho está vazio',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text('Adicione produtos ao seu carrinho'),
                      ],
                    ),
                  ],
                ),
              )
              : ListView.builder(
                // cart.itens.length define quantos itens o ListView vai renderizar
                itemCount: cart.itens.length,
                itemBuilder: (context, index) {
                  // busca o item da posição atual da lista
                  final item = cart.itens[index];

                  return Container(
                    child: Padding(
                      padding: const EdgeInsets.all(12),

                      child: IntrinsicHeight(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,

                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: Image.asset(
                                item.urlImagem ?? '',
                                width: 80,
                                height: 80,
                                filterQuality: FilterQuality.high,
                              ),
                            ),

                            // VerticalDivider(thickness: 1.4, width: 18),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,

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
                                  style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 16,
                                    color: colors.secondary,
                                  ),
                                ),
                                CounterWidget(
                                  scale: 0.8,
                                  counter: item.quantity,
                                  onIncrease: () {
                                    cart.adicionarItem(item);
                                  },
                                  onDecrease: () {
                                    cart.removerItem(item);
                                  },
                                ),
                              ],
                            ),
                            const Spacer(),
                            IconButton(
                              icon: SvgPicture.asset(
                                'assets/Icons/lixeira.svg',
                                width: 24,
                                height: 24,
                              ),
                              onPressed: () {
                                cart.removerProduto(item);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),

      bottomNavigationBar:
          cart.itens.isNotEmpty
              ? Padding(
                padding: const EdgeInsets.all(16),

                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            'R\$ ${cart.total.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 22,
                              color: colors.secondary,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // opcional, mas recomendado
                    Expanded(
                      flex: 4,

                      child: SizedBox(
                        height: 55,
                        child: ElevatedButton(
                          onPressed: () async {
                            try {
                              final box = Hive.box('appBox');
                              final addresses = box.get(
                                'addresses',
                                defaultValue: [],
                              );
                              if (addresses.isEmpty) {
                                await showDialog(
                                  context: context,
                                  builder:
                                      (context) => AlertDialog(
                                        title: const Text(
                                          '[ Erro ] ao finalizar pedido',
                                        ),
                                        content: const Text(
                                          'Nenhuma endereço cadastrado!',
                                        ),
                                        actions: [
                                          TextButton(
                                            child: const Text(
                                              'Cancelar',
                                              style: TextStyle(
                                                color: Colors.black,
                                              ),
                                            ),

                                            onPressed: () {
                                              Navigator.pop(
                                                context,
                                              ); // fecha o dialog
                                            },
                                          ),
                                          TextButton(
                                            child: const Text(
                                              'Adicionar',
                                              style: TextStyle(
                                                color: Colors.black,
                                              ),
                                            ),
                                            onPressed: () {
                                              Navigator.pop(
                                                context,
                                              ); // fecha o dialog
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder:
                                                      (_) =>
                                                          const AddressPage(),
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                );
                                return;
                              }
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => CheckoutPaymentPage(
                                        total: cart.total,
                                      ),
                                ),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(e.toString())),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colors.secondary,
                            minimumSize: const Size(double.infinity, 60),
                            foregroundColor: colors.onSecondary,

                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),

                              side: BorderSide(color: colors.secondary),
                            ),

                            padding: const EdgeInsets.symmetric(vertical: 8),
                          ),
                          child: Text(
                            'Comprar agora',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: colors.primary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
              : null,
    );
  }
}
