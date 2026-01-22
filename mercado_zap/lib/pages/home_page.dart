import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mercado_zap/database/read_database.dart';
import 'package:mercado_zap/models/Address.dart';
import 'package:mercado_zap/models/product.dart';
import 'package:mercado_zap/pages/dialog_local.dart';
import 'package:mercado_zap/providers/product_provider.dart';
import 'package:mercado_zap/widgets/BannerCarousel.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _productController = TextEditingController();
  late Box box;

  @override
  /*******  40817905-9eed-4a6a-bc3e-d7424a4713d7  *******/
  void initState() {
    super.initState();
    box = Hive.box('appBox');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(context, listen: false).carregarProdutos();
    });
  }

  String getLocation() {
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

      body: Column(
        children: [
          Padding(
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
                      ValueListenableBuilder(
                        valueListenable: Hive.box(
                          'appBox',
                        ).listenable(keys: ['addresses']),
                        builder: (context, Box box, _) {
                          return Text(
                            getLocation(),
                            style: TextStyle(fontWeight: FontWeight.w500),
                          );
                        },
                      ),

                      Spacer(),
                      const Icon(Icons.arrow_forward_ios),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
                Container(
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
                      labelText: 'Search Anything...',
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
                      floatingLabelStyle: TextStyle(
                        color: colors.primaryContainer,
                      ),

                      contentPadding: EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(child: BannerCarousel()),

          Expanded(
            child: GridView.builder(
              itemCount: products.products.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 5, // Espaçamento horizontal entre os itens
                mainAxisSpacing: 5,
                childAspectRatio:
                    0.75, // <<< ESTA LINHA// Espaçamento vertical entre os itens),
                // Define 2 colunas fixas
              ),
              itemBuilder: (context, index) {
                final product = products.products[index];

                return SizedBox(
                  height: 160,
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              product.name,

                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: colors.onSurface,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
