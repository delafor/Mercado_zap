import 'package:flutter/material.dart';
import 'package:mercado_zap/models/cart_item.dart';
import 'package:mercado_zap/providers/cart_provider.dart';
import 'package:mercado_zap/providers/product_provider.dart';
import 'package:mercado_zap/widgets/choose_payment.dart';
import 'package:provider/provider.dart';

import '../providers/payment_provider.dart';
import 'pix_payment_page.dart';

class CheckoutPaymentPage extends StatelessWidget {
  final double total;
  final List<CartItem>? produtos;

  const CheckoutPaymentPage({super.key, this.produtos, required this.total});

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();
    final paymentProvider = context.watch<PaymentProvider>();
    final itens = produtos ?? cartProvider.itens;
    print(cartProvider.itens.length);
    return Scaffold(
      appBar: AppBar(title: const Text('Pagamento')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // CONTAINER DOS PRODUTOS
            Container(
              padding: const EdgeInsets.all(16),

              constraints: const BoxConstraints(maxHeight: 200),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
              ),

              child: SingleChildScrollView(
                child:
                    itens.isEmpty
                        ? const Center(
                          child: Text(
                            'Carrinho vazio',
                            style: TextStyle(color: Colors.black, fontSize: 18),
                          ),
                        )
                        : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Resumo do Pedido",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            ...itens.map((produto) {
                              return InfoRow(
                                quantidade: "${produto.quantity}x",
                                text: " ${produto.name}",
                                valor:
                                    "R\$ ${(produto.price * produto.quantity).toStringAsFixed(2)}",
                              );
                            }).toList(),
                            Divider(thickness: 1, color: Colors.grey),

                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "Subtotal",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),

                                Text(
                                  " R\$ ${total.toStringAsFixed(2)}",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
              ),
            ),

            const SizedBox(height: 30),

            // CONTAINER PAGAMENTO
            Container(
              padding: const EdgeInsets.all(16),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    'Método de pagamento',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  ChoosePayment(
                    text: "PIX",
                    icon: Icons.pix,
                    cor: Colors.green,

                    onPressed: () async {
                      await paymentProvider.createPayment(amount: total);

                      if (!context.mounted) return;

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const PixPaymentPage(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 10),

                  ChoosePayment(
                    text: "Cartão",
                    icon: Icons.card_giftcard,
                    cor: Colors.green,

                    onPressed: () async {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final String text;
  final String quantidade;
  final String valor;

  const InfoRow({
    super.key,
    required this.quantidade,
    required this.text,
    required this.valor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [
          Expanded(
            child: Row(
              children: [
                Text(
                  quantidade,

                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                SizedBox(width: 10),
                Text(
                  text,

                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),

          // TITULO
          Text(
            valor,

            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
