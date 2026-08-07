import 'package:flutter/material.dart';

import '../../../../app/core/constants/app_assets.dart';
import '../../domain/entities/product.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product, required this.onAdd, required this.onBuy});

  final Product product;
  final VoidCallback onAdd;
  final VoidCallback onBuy;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  width: double.infinity,
                  child: product.imageUrl == null || product.imageUrl!.isEmpty
                      ? ColoredBox(color: colors.surfaceContainerHighest, child: const Icon(Icons.image_outlined, size: 42))
                      : Image.asset(
                          product.imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => ColoredBox(color: colors.surfaceContainerHighest, child: const Icon(Icons.image_outlined, size: 42)),
                        ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(product.name, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
            const SizedBox(height: 4),
            Text('R\$ ${product.price.toStringAsFixed(2)} / ${product.unit}', style: TextStyle(color: colors.primary, fontWeight: FontWeight.w700, fontSize: 16)),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onAdd,
                    icon: Image.asset(AppAssets.cartIcon, width: 17, height: 17, color: colors.primary),
                    label: const Text('Adicionar'),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(onPressed: onBuy, icon: const Icon(Icons.shopping_bag_outlined)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
