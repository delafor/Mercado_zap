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
        'name': 'Açúcar Refinado 1kg',
        'category': 'Mercearia',
        'description': 'Açúcar refinado branco',
        'urlImagem': 'assets/images/acucar.png',
        'unidade': 'kg',
        'price': 4.90,
      },
      {
        'id': 4,
        'name': 'Leite Integral 1L',
        'category': 'Laticínios',
        'description': 'Leite integral fresco',
        'urlImagem': 'assets/images/leite.png',
        'unidade': 'L',
        'price': 6.50,
      },
      {
        'id': 5,
        'name': 'Ovos Brancos 12un',
        'category': 'Laticínios',
        'description': 'Ovos brancos grandes',
        'urlImagem': 'assets/images/ovos.png',
        'unidade': 'un',
        'price': 10.90,
      },
      {
        'id': 6,
        'name': 'Macarrão Espaguete 500g',
        'category': 'Massas',
        'description': 'Macarrão espaguete tipo 1',
        'urlImagem': 'assets/images/macarrao.png',
        'unidade': 'g',
        'price': 5.20,
      },
      {
        'id': 7,
        'name': 'Molho de Tomate 340g',
        'category': 'Molhos',
        'description': 'Molho de tomate tradicional',
        'urlImagem': 'assets/images/molho_tomate.png',
        'unidade': 'g',
        'price': 3.80,
      },
      {
        'id': 8,
        'name': 'Café Torrado 250g',
        'category': 'Bebidas',
        'description': 'Café torrado e moído',
        'urlImagem': 'assets/images/cafe.png',
        'unidade': 'g',
        'price': 7.50,
      },
      {
        'id': 9,
        'name': 'Óleo de Soja 900ml',
        'category': 'Óleos',
        'description': 'Óleo de soja refinado',
        'urlImagem': 'assets/images/oleo.png',
        'unidade': 'ml',
        'price': 9.90,
      },
      {
        'id': 10,
        'name': 'Sal Refinado 1kg',
        'category': 'Temperos',
        'description': 'Sal refinado fino',
        'urlImagem': 'assets/images/sal.png',
        'unidade': 'kg',
        'price': 2.90,
      },
      {
        'id': 11,
        'name': 'Pão Francês 500g',
        'category': 'Padaria',
        'description': 'Pão francês fresco',
        'urlImagem': 'assets/images/pao.png',
        'unidade': 'g',
        'price': 7.00,
      },
      {
        'id': 12,
        'name': 'Queijo Mussarela 500g',
        'category': 'Laticínios',
        'description': 'Queijo mussarela fatiado',
        'urlImagem': 'assets/images/queijo.png',
        'unidade': 'g',
        'price': 24.90,
      },
    ];
    final ProdutosExistentes =
        (box.get('products', defaultValue: <Map>[]) as List).cast<Map>();

    for (var item in novosProdutos) {
      if (!ProdutosExistentes.any((e) => e['id'] == item['id'])) {
        ProdutosExistentes.add(item);
      }
    }
    await box.put('products', ProdutosExistentes);
  }
}
