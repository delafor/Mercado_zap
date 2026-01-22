import 'package:flutter/material.dart';
import 'package:mercado_zap/pages/cart_page.dart';
import 'package:mercado_zap/pages/checkout_page.dart';
import 'package:mercado_zap/pages/home_page.dart';
import 'package:mercado_zap/providers/product_provider.dart';

class MainPage extends StatefulWidget {
  // const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  final List<Widget> _telas = [HomePage(), CartPage()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _telas[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Carrinho',
          ),
        ],
      ),
    );
  }
}
