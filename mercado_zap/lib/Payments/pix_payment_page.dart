import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:provider/provider.dart';

import '../providers/payment_provider.dart';
import 'success_payment_page.dart';

class PixPaymentPage extends StatefulWidget {
  final double amount;
  const PixPaymentPage({super.key, required this.amount});

  @override
  State<PixPaymentPage> createState() => _PixPaymentPageState();
}

class _PixPaymentPageState extends State<PixPaymentPage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      final provider = context.read<PaymentProvider>();

      await provider.createPayment(amount: widget.amount);

      provider.startChecking();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PaymentProvider>();

    if (provider.approved) {
      Future.microtask(() {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const SuccessPaymentPage()),
        );
      });
    }
    if (provider.loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Pagamento PIX')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),

            const Text(
              'Escaneie o QR Code',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: 220,
              height: 220,
              child: PrettyQrView.data(data: provider.pixCode),
            ),

            const SizedBox(height: 30),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: SelectableText(provider.pixCode),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () async {
                  await Clipboard.setData(
                    ClipboardData(text: provider.pixCode),
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Código copiado')),
                  );
                },
                child: const Text('Copiar código PIX'),
              ),
            ),

            const SizedBox(height: 40),

            const CircularProgressIndicator(),

            const SizedBox(height: 16),

            const Text('Aguardando pagamento...'),
          ],
        ),
      ),
    );
  }
}
