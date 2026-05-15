import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:abacatepay/abacatepay.dart';
import 'package:hive_flutter/adapters.dart';

final abacatePay = AbacatePay(apiKey: 'abc_dev_5C2BEhugW6G1AtHyUuTbFMfF');

class CheckoutPage extends StatefulWidget {
  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  String patmentMethod = 'pix';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.amber,
              ),

              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    'Total: R\$ 10,00',
                  ), // eles vao receber o valor real do pagamento
                  Text(
                    'Forma de pagamento: Pix',
                  ), // tudo aqui ainda é so visual
                ],
              ),
            ),

            const SizedBox(height: 30),

            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        patmentMethod = 'pix';
                      });
                    },

                    child: Container(
                      padding: const EdgeInsets.all(20),

                      decoration: BoxDecoration(
                        color: patmentMethod == 'pix'
                            ? Colors.amber
                            : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.amber),
                      ),
                      child: const Center(child: Text('Pix')),
                    ),
                  ),
                ),
                const SizedBox(width: 10),

                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        patmentMethod = 'card';
                      });
                    },

                    child: Container(
                      padding: const EdgeInsets.all(20),

                      decoration: BoxDecoration(
                        color: patmentMethod == 'card'
                            ? Colors.amber
                            : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.amber),
                      ),

                      child: const Center(child: Text('Cartão')),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {},

              child: const Text('Finalizar Compra'),
            ),
          ],
        ),
      ),
    );
  }
}
