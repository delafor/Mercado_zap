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
      'Mercearia',
      'Hortifruti',
      'Carnes',
      'Laticínios',
      'Padaria',
      'Bebidas',
      'Limpeza',
      'Higiene',
      'Beleza e Cabelo',
      'Pet',
      'Congelados',
      'Snacks',
    ];

    final Map<String, IconData> categoryIcons = {
      'Mercearia': Icons.shopping_basket,
      'Hortifruti': Icons.eco,
      'Carnes': Icons.set_meal,
      'Laticínios': Icons.egg,
      'Padaria': Icons.bakery_dining,
      'Bebidas': Icons.local_drink,
      'Limpeza': Icons.cleaning_services,
      'Higiene': Icons.health_and_safety,
      'Beleza e Cabelo': Icons.face,
      'Pet': Icons.pets,
      'Congelados': Icons.ac_unit,
      'Snacks': Icons.fastfood,
    };

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
                  Icon(
                    categoryIcons[category],
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                  const SizedBox(width: 5),
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
