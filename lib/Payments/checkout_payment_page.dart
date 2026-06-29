import 'package:flutter/material.dart';
import 'package:mercado_zap/models/cart_item.dart';
import 'package:mercado_zap/providers/cart_provider.dart';
import 'package:mercado_zap/widgets/choose_payment.dart';
import 'package:mercado_zap/widgets/info_row.dart';
import 'package:provider/provider.dart';
import 'pix_payment_page.dart';

class CheckoutPaymentPage extends StatefulWidget {
  final double total;
  final List<CartItem>? produtos;

  const CheckoutPaymentPage({super.key, this.produtos, required this.total});
  _CheckoutPaymentPage createState() => _CheckoutPaymentPage();
}

class _CheckoutPaymentPage extends State<CheckoutPaymentPage> {
  String selectedPayment = 'PIX';
  double taxaEntrega = 3;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final cartProvider = context.watch<CartProvider>();

    final itens = widget.produtos ?? cartProvider.itens;
    final cart = context.watch<CartProvider>();
    double totalFinal = widget.total + taxaEntrega;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pagamento',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Text('Finalize sua compra', style: TextStyle(fontSize: 14)),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
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
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 5),
                    ],
                  ),

                  child: SingleChildScrollView(
                    child:
                        itens.isEmpty
                            ? const Center(
                              child: Text(
                                'Carrinho vazio',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                ),
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
                                      " R\$ ${widget.total.toStringAsFixed(2)}",
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
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 5),
                    ],
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
                        title: "PIX",
                        subtitle: 'Pagamento instantâneo',
                        icon: Icons.pix,
                        iconColor: Colors.green,

                        isSelected: selectedPayment == 'PIX',

                        onChanged: (value) {
                          setState(() {
                            selectedPayment = 'PIX';
                          });
                        },
                      ),

                      const SizedBox(height: 10),

                      ChoosePayment(
                        title: "Cartão de crédito",
                        subtitle: 'Pague em até 3x sem juros',
                        icon: Icons.card_giftcard,
                        iconColor: Colors.black,
                        isSelected: selectedPayment == 'Cartão',

                        onChanged: (value) {
                          setState(() {
                            selectedPayment = 'Cartão';
                          });
                        },

                        onPressed: () async {},
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),

                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 5),
                    ],
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text(
                        'Resumo do pagamento',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      InfoRow(
                        text: "Subtotal",
                        valor: 'R\$ ${widget.total.toStringAsFixed(2)}',
                      ),
                      InfoRow(
                        text: 'Entrega',
                        valor: 'R\$ ${taxaEntrega.toStringAsFixed(2)}',
                      ),
                      Divider(thickness: 1, color: Colors.grey),

                      InfoRow(
                        total: 'Total',
                        valorTotal: 'R\$ ${totalFinal.toStringAsFixed(2)}',
                      ),

                      ElevatedButton(
                        onPressed: () async {
                          if (selectedPayment == 'PIX') {
                            if (!context.mounted) return;

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => PixPaymentPage(amount: totalFinal),
                              ),
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
                          'Pagar com ${selectedPayment}',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: colors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
