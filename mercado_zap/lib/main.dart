import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mercado_zap/models/address.dart';
import 'package:mercado_zap/providers/payment_provider.dart';
import 'package:mercado_zap/theme.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:mercado_zap/providers/cart_provider.dart';
import 'database/seed_database.dart';
import 'pages/main_page.dart';
import 'providers/cart_provider.dart';
import 'providers/product_provider.dart';
import 'providers/pdv_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  await Hive.openBox('appBox');

  await Hive.openBox<Address>('addresses');
  await Hive.box('appBox').clear(); // ← limpa TUDO do appBox
  await SeedDatabase.seed();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PaymentProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProxyProvider<CartProvider, PdvProvider>(
          create: (context) => PdvProvider(cart: context.read<CartProvider>()),
          update: (_, cart, pdv) => pdv ?? PdvProvider(cart: cart),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mercado Zap',
      theme: AppThemes.light(),
      home: MainPage(),
    );
  }
}
