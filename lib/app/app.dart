import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'features/cart/presentation/controllers/cart_controller.dart';
import 'features/cart/presentation/pages/cart_page.dart';
import 'features/catalog/presentation/controllers/catalog_controller.dart';
import 'features/catalog/presentation/pages/home_page.dart';
import 'features/orders/presentation/pages/orders_page.dart';

class MercadoZapApp extends StatelessWidget {
  const MercadoZapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CatalogController()..load()),
        ChangeNotifierProvider(create: (_) => CartController()..load()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Mercado Zap',
        theme: AppTheme.light(),
        home: const AppShell(),
      ),
    );
  }
}

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = const [HomePage(), CartPage(), OrdersPage()];

    return Scaffold(
      body: IndexedStack(index: index, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (value) => setState(() => index = value),
        destinations: [
          const NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Início'),
          NavigationDestination(
            icon: _CartIcon(controller: context.watch<CartController>()),
            selectedIcon: _CartIcon(controller: context.watch<CartController>(), selected: true),
            label: 'Carrinho',
          ),
          const NavigationDestination(icon: Icon(Icons.receipt_long_outlined), selectedIcon: Icon(Icons.receipt_long), label: 'Pedidos'),
        ],
      ),
    );
  }
}

class _CartIcon extends StatelessWidget {
  const _CartIcon({required this.controller, this.selected = false});

  final CartController controller;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Badge(
      isLabelVisible: controller.totalQuantity > 0,
      label: Text('${controller.totalQuantity}'),
      child: Icon(selected ? Icons.shopping_cart : Icons.shopping_cart_outlined),
    );
  }
}
