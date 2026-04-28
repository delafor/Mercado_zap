import 'package:flutter/material.dart';
import 'package:mercado_zap/models/category.dart';
import 'package:mercado_zap/providers/product_provider.dart';
import 'package:provider/provider.dart';

class CategoryCarousel extends StatelessWidget {
  const CategoryCarousel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProductProvider>();
    final List<String> categories = [
      'Todos',
      'Grãos',
      'Mercearia',
      'Laticínios',
      'Massas',
      'Molhos',
      'Bebidas',
      'Óleos',
      'Temperos', // colocar os filtros certos

      'Padaria',
    ];

    return SizedBox(
      height: 40,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = provider.selectedCategory == category;
          return GestureDetector(
            onTap: () {
              final selected = context
                  .read<ProductProvider>()
                  .selecionarCategoria(category);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 5),
              decoration: BoxDecoration(
                color: isSelected
                    ? Theme.of(context).colorScheme.onPrimary
                    : Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  Text(
                    category,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
