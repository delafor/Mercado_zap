import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../app/core/constants/app_assets.dart';
import '../../../cart/presentation/controllers/cart_controller.dart';
import '../../domain/entities/product.dart';
import '../controllers/catalog_controller.dart';
import '../widgets/product_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final searchController = TextEditingController();
  Timer? debounce;

  @override
  void dispose() {
    debounce?.cancel();
    searchController.dispose();
    super.dispose();
  }

  void onSearch(String value) {
    debounce?.cancel();
    debounce = Timer(const Duration(milliseconds: 300), () {
      if (mounted) context.read<CatalogController>().search(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final catalog = context.watch<CatalogController>();
    final colors = Theme.of(context).colorScheme;

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          expandedHeight: 105,
          backgroundColor: colors.primary,
          title: Row(
            children: [
              Image.asset(AppAssets.logo, width: 38, height: 38),
              const SizedBox(width: 10),
              const Text('Mercado Zap', style: TextStyle(fontWeight: FontWeight.w800)),
            ],
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(62),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: TextField(
                controller: searchController,
                onChanged: onSearch,
                decoration: const InputDecoration(hintText: 'Buscar produtos ou categorias', prefixIcon: Icon(Icons.search)),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(child: _BannerStrip()),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 52,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              scrollDirection: Axis.horizontal,
              itemCount: catalog.categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, index) {
                final category = catalog.categories[index];
                return ChoiceChip(
                  label: Text(category),
                  selected: catalog.category == category,
                  onSelected: (_) => catalog.selectCategory(category),
                );
              },
            ),
          ),
        ),
        if (catalog.isLoading)
          const SliverFillRemaining(hasScrollBody: false, child: Center(child: CircularProgressIndicator()))
        else if (catalog.error != null)
          SliverFillRemaining(hasScrollBody: false, child: Center(child: Text(catalog.error!)))
        else if (catalog.products.isEmpty)
          const SliverFillRemaining(hasScrollBody: false, child: Center(child: Text('Nenhum produto encontrado.')))
        else
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(12, 4, 12, 24),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final product = catalog.products[index];
                  return ProductCard(
                    product: product,
                    onAdd: () => context.read<CartController>().addProduct(product),
                    onBuy: () => _showProduct(context, product),
                  );
                },
                childCount: catalog.products.length,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: .64),
            ),
          ),
      ],
    );
  }

  void _showProduct(BuildContext context, Product product) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(product.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            Text(product.description.isEmpty ? 'Produto disponível no Mercado Zap.' : product.description),
            const SizedBox(height: 16),
            Text('R\$ ${product.price.toStringAsFixed(2)}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
            const SizedBox(height: 16),
            SizedBox(width: double.infinity, child: FilledButton.icon(onPressed: () { context.read<CartController>().addProduct(product); Navigator.pop(context); }, icon: const Icon(Icons.add_shopping_cart), label: const Text('Adicionar ao carrinho'))),
          ],
        ),
      ),
    );
  }
}

class _BannerStrip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: PageView(
        children: [AppAssets.banner1, AppAssets.banner2, AppAssets.banner3]
            .map((asset) => Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: ClipRRect(borderRadius: BorderRadius.circular(18), child: Image.asset(asset, fit: BoxFit.cover)),
                ))
            .toList(),
      ),
    );
  }
}
