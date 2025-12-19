import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Badge(
            label: Text(
              '2',
            ), // aaqui vai receber conforme quantos itens tiverem no carrinho
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.shopping_cart),
            ),
          ),
        ],
        elevation: 5,

        title: Container(
          child: TextField(
            controller: _searchController,
            onChanged: (value) {
              print(value);
            },

            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Pesquisar no MercadoZap',
              floatingLabelStyle: TextStyle(color: Colors.black),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
      ),

      body: GridView.count(
        crossAxisCount: 2, // Define 2 colunas fixas
        crossAxisSpacing: 5, // Espaçamento horizontal entre os itens
        mainAxisSpacing: 5, // Espaçamento vertical entre os itens
        children: <Widget>[
          Container(
            color: Colors.teal[200],
            child: const Center(child: Text('Item 2')),
          ),
          Container(
            color: Colors.teal[300],
            child: const Center(child: Text('Item 3')),
          ),
          Container(
            color: Colors.teal,
            child: const Center(child: Text('Item 1')),
          ),
        ],
      ),
    );
  }
}
