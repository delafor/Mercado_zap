import 'package:flutter/material.dart';
import 'package:mercado_zap/pages/cart_page.dart';
import 'package:mercado_zap/pages/checkout_page.dart';
import 'package:mercado_zap/pages/home_page.dart';
import 'package:mercado_zap/pages/pedidos.dart';
import 'package:mercado_zap/providers/product_provider.dart';
import 'package:provider/provider.dart';
import 'package:mercado_zap/providers/cart_provider.dart';

class MainPage extends StatefulWidget {
  // const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  final List<Widget> _telas = [HomePage(), CartPage(), PedidosPage()];
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final quantidade = cart.quantidadeTotal;
    //se caso eu precise exibir quntidade de tal produto eu chamo igual e so coloco

    //Total de produtos diferentes: cart.itens.length

    //Total de unidades: cart.quantidadeTotal

    //Total de unidades:cart.total

    return Scaffold(
      body: _telas[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),

          BottomNavigationBarItem(
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(Icons.shopping_cart),

                if (quantidade > 0)
                  Positioned(
                    right: -5,
                    top: -5,
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '$quantidade',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ),
              ],
            ),
            label: 'Carrinho',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.badge_sharp),
            label: 'Pedidos',
          ),
        ],
      ),
    );
  }
}
