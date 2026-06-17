import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:provider/provider.dart';
import 'package:hive/hive.dart';
import '../providers/cart_provider.dart';
import '../providers/payment_provider.dart';
import 'success_payment_page.dart';

class PixPaymentPage extends StatefulWidget {
  final double amount;
  const PixPaymentPage({super.key, required this.amount});

  @override
  State<PixPaymentPage> createState() => _PixPaymentPageState();
}

class _PixPaymentPageState extends State<PixPaymentPage> {
  bool pedidoSalvo = false;
  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      final provider = context.read<PaymentProvider>();

      await provider.createPayment(amount: widget.amount, provider: null);

      provider.startChecking();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PaymentProvider>();
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    if (provider.approved && !pedidoSalvo) {
      pedidoSalvo = true;

      Future.microtask(() async {
        try {
          final box = Hive.box('appBox');
          final pedidosBox = Hive.box('pedidos');
          final cart = context.read<CartProvider>();

          final addresses = box.get('addresses', defaultValue: []);

          if (addresses is List && addresses.isNotEmpty) {
            final ultimoEndereco = Map<String, dynamic>.from(addresses.last);

            final pedido = {
              'id': DateTime.now().millisecondsSinceEpoch,
              'numeroPedido': DateTime.now().millisecondsSinceEpoch,
              'nome': ultimoEndereco['name'] ?? '',
              'telefone': ultimoEndereco['numberTel'] ?? '',
              'endereco':
                  '${ultimoEndereco['nameRua'] ?? ''}, '
                  '${ultimoEndereco['numberCasa'] ?? ''} - '
                  '${ultimoEndereco['bairro'] ?? ''}',
              'complemento': ultimoEndereco['complemento'] ?? '',
              'total': widget.amount,
              'status': 'Pago',
              'data': DateTime.now().toString(),
              'itens':
                  cart.itens.map((item) {
                    return {
                      'name': item.name,
                      'price': item.price,
                      // 'total': item.price + item.quantity,
                      'quantity': item.quantity,
                    };
                  }).toList(),
            };

            await pedidosBox.add(pedido);
          }
          cart.limpar();

          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const SuccessPaymentPage()),
            );
          }
        } catch (e, stackTrace) {
          debugPrint(
            'Erro ao salvar pedido: $e\n$stackTrace',
          ); // se o hive dar erro vou saber o resultado
          // Mesmo com erro, navega para teste
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Erro ao salvar pedido')),
            );
          }
        }
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
