import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/cart_controller.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartController>();
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Meu carrinho')),
      body: cart.items.isEmpty
          ? const Center(child: Text('Seu carrinho está vazio.'))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: cart.items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, index) {
                final item = cart.items[index];
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: SizedBox(
                            width: 72,
                            height: 72,
                            child: item.imageUrl == null || item.imageUrl!.isEmpty
                                ? ColoredBox(color: colors.surfaceContainerHighest, child: const Icon(Icons.image_outlined))
                                : Image.asset(item.imageUrl!, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported_outlined)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.name, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w700)),
                              const SizedBox(height: 4),
                              Text('R\$ ${item.price.toStringAsFixed(2)}'),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  IconButton(onPressed: () => cart.decrement(item), icon: const Icon(Icons.remove_circle_outline)),
                                  Text('${item.quantity}', style: const TextStyle(fontWeight: FontWeight.w700)),
                                  IconButton(onPressed: () => cart.increment(item), icon: const Icon(Icons.add_circle_outline)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        IconButton(onPressed: () => cart.remove(item), icon: const Icon(Icons.delete_outline)),
                      ],
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: cart.items.isEmpty
          ? null
          : SafeArea(
              minimum: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Row(
                children: [
                  Expanded(child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Total'), Text('R\$ ${cart.total.toStringAsFixed(2)}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800))])),
                  FilledButton(onPressed: () {}, child: const Text('Continuar')),
                ],
              ),
            ),
    );
  }
}
