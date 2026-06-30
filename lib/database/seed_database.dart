import 'package:hive_flutter/adapters.dart';

class SeedDatabase {
  static Future<void> seed() async {
    final box = Hive.box('appBox');

    final novosProdutos = [
      {
        'id': 1,
        'name': 'Arroz Branco 5kg',
        'category': 'Grãos',
        'description': 'Arroz tipo 1, pacote de 5kg',
        'urlImagem': 'assets/images/arroz.png',
        'unidade': 'kg',
        'price': 25.90,
      },
      {
        'id': 2,
        'name': 'Feijão Carioca 1kg',
        'category': 'Grãos',
        'description': 'Feijão carioca tipo 1',
        'urlImagem': 'assets/images/feijao.png',
        'unidade': 'kg',
        'price': 8.50,
      },
      {
        'id': 3,
        'name': 'Biscoito Recheado 140g',
        'category': 'Snacks',
        'description': 'Biscoito sabor chocolate',
        'urlImagem': 'assets/images/biscoito.png',
        'unidade': 'g',
        'price': 3.50,
      },
      {
        'id': 4,
        'name': 'Refrigerante Cola 2L',
        'category': 'Bebidas',
        'description': 'Refrigerante sabor cola',
        'urlImagem': 'assets/images/refri.png',
        'unidade': 'L',
        'price': 8.99,
      },
      {
        'id': 5,
        'name': 'carrinho 1kg',
        'category': 'Bebidas',
        'description': 'Refrigerante sabor cola',
        'urlImagem': 'assets/images/image4.png',
        'unidade': 'L',
        'price': 8.99,
      },
    ];

    final produtosExistentes =
        (box.get('products', defaultValue: <Map>[]) as List).cast<Map>();

    for (var item in novosProdutos) {
      if (!produtosExistentes.any((e) => e['id'] == item['id'])) {
        produtosExistentes.add(item);
      }
    }

    await box.put('products', produtosExistentes);
  }
}
