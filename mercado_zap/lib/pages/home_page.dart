import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mercado_zap/database/read_database.dart';
import 'package:mercado_zap/models/Address.dart';
import 'package:mercado_zap/models/cart_item.dart';
import 'package:mercado_zap/models/product.dart';
import 'package:mercado_zap/pages/dialog_local.dart';
import 'package:mercado_zap/providers/product_provider.dart';
import 'package:mercado_zap/widgets/BannerCarousel.dart';
import 'package:provider/provider.dart';
import 'package:mercado_zap/providers/cart_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _productController = TextEditingController();
  late Box box;
  String? _cachedLocation; // ✅ cache do endereço parseado
  @override
  void initState() {
    super.initState();
    box = Hive.box('appBox');
    _cachedLocation = _parseLocation(); // ✅ parseia 1x na inicialização

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(context, listen: false).carregarProdutos();
    });
  }

  @override
  void dispose() {
    _productController.dispose(); //evita memory leak
    super.dispose();
  }

  String _parseLocation() {
    final data = box.get('addresses', defaultValue: <Map<String, dynamic>>[]);
    final adresses = (data as List)
        .map((item) => Address.fromMap(Map<String, dynamic>.from(item)))
        .toList();

    if (adresses.isEmpty) return 'Adicione um endereço';

    final endereco = adresses.last;
    return '${endereco.nameRua}, ${endereco.numberCasa}, ${endereco.bairro}';
  }

  Widget build(BuildContext context) {
    final products = context.watch<ProductProvider>();
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: RichText(
          text: TextSpan(
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),

            children: [
              TextSpan(
                text: 'Hyper',
                style: TextStyle(color: colors.onPrimary),
              ),
              TextSpan(
                text: 'Mart',
                style: TextStyle(color: colors.secondary),
              ),
            ],
          ),
        ),

        leading: Padding(
          padding: const EdgeInsets.all(3),
          child: Image.asset('lib/assets/logo/logo01.png'),
        ),

        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/cart'),
            icon: Icon(Icons.notifications, color: colors.onPrimary),
          ),
        ],

        elevation: 5,
      ),

      body: CustomScrollView(
        slivers: [
          // topo q some ao subir/ scrollar para cima
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddLocalDialog(),
                        ),
                      );

                      //set
                    },

                    child: Row(
                      children: [
                        Container(
                          width: 45,

                          height: 45,
                          decoration: BoxDecoration(
                            color: colors.onSecondary,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.location_on,

                            color: theme.primaryColor,
                            size: 30,
                          ),
                        ),
                        const SizedBox(width: 12),
                        ValueListenableBuilder<Box>(
                          valueListenable: Hive.box(
                            'appBox',
                          ).listenable(keys: ['addresses']),
                          builder: (context, Box box, _) {
                            return Text(
                              _parseLocation(),
                              style: TextStyle(fontWeight: FontWeight.w500),
                            );
                          },
                        ),

                        Spacer(),
                        const Icon(Icons.arrow_forward_ios),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          //Search fixa, so a barra de pesquisa ficará no topo da tela ao scrollar
          SliverAppBar(
            pinned: true,
            automaticallyImplyLeading: false,
            toolbarHeight: 85,
            backgroundColor: theme.scaffoldBackgroundColor,
            elevation: 0,

            title: Container(
              decoration: BoxDecoration(
                color: colors.primary,
                borderRadius: BorderRadius.circular(10),
              ),

              child: TextField(
                style: TextStyle(color: colors.onSurface),
                controller: _productController,
                onChanged: (value) {
                  // setState(() {
                  //   searchQuery = value;
                  // });
                  context.read<ProductProvider>().buscarProduto(value);
                },

                decoration: InputDecoration(
                  labelText: 'Buscar produutos, categorias...',
                  labelStyle: TextStyle(color: theme.cardColor),

                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: colors.primary),
                    borderRadius: BorderRadius.circular(10),
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: colors.primaryContainer),
                    borderRadius: BorderRadius.circular(10),
                  ),

                  prefixIcon: IconButton(
                    icon: Icon(Icons.search, color: colors.secondary),
                    onPressed: () {
                      context.read<ProductProvider>().buscarProduto(
                        _productController.text,
                      );
                    },
                  ),

                  hintText: 'Pesquisar no MercadoZap',
                  floatingLabelStyle: TextStyle(color: colors.primaryContainer),

                  contentPadding: EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ),

          //AQUI VAI SER A OPCAO DE ESCOLHER AS CATEGORIAS

          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(top: 10),
              child: BannerCarousel(),
            ),
          ),

          // const SizedBox(child: BannerCarousel()),
          SliverPadding(
            padding: const EdgeInsets.all(8),

            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate((context, index) {
                final product = products.products[index];

                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,

                      children: [
                        const SizedBox(height: 4),
                        Expanded(
                          flex: 3,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              'lib/assets/banner/image1.png', // ajuste para o campo do seu modelo
                              // height: 10,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                color: colors.primaryContainer,
                                child: Icon(
                                  Icons.image_not_supported,
                                  color: colors.onPrimaryContainer,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.name,

                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: colors.onSurface,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'R\$ ${product.price}' + ' /${product.unidade}',
                                style: TextStyle(
                                  color: colors.secondary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 15),
                        SizedBox(
                          height: 35,
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              final cartItem = CartItem.fromProduct(product);
                              context.read<CartProvider>().adicionarItem(
                                cartItem,
                              );

                              print('Item adicionado ao carrinho');
                              //lógica de adicionar ao carrinho
                              // ex: context.read<CartProvider>().addItem(product);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colors.secondary,
                              foregroundColor: colors.onSecondary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 8),
                            ),
                            child: const Text(
                              'Comprar',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              final cartItem = CartItem.fromProduct(product);
                              context.read<CartProvider>().adicionarItem(
                                cartItem,
                              );

                              print('Item adicionado ao carrinho');
                              //lógica de adicionar ao carrinho
                              // ex: context.read<CartProvider>().addItem(product);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colors.secondary,
                              foregroundColor: colors.onSecondary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 8),
                            ),
                            child: const Text(
                              'Adicionar',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }, childCount: products.products.length),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
                childAspectRatio: 0.75,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
