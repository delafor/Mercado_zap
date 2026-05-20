import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/payment_provider.dart';
import 'pix_payment_page.dart';

class CheckoutPaymentPage extends StatelessWidget {
  final double total;

  const CheckoutPaymentPage({
    super.key,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PaymentProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pagamento'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    'R\$ ${total.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: provider.loading
                    ? null
                    : () async {
                        await provider.createPayment(
                          amount: total,
                        );

                        if (!context.mounted) return;

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const PixPaymentPage(),
                          ),
                        );
                      },
                child: provider.loading
                    ? const CircularProgressIndicator()
                    : const Text('Gerar PIX'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}