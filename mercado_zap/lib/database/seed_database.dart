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
      {
        'id': 13,
        'name': 'Peito de Frango 1kg',
        'category': 'Carnes',
        'description': 'Peito de frango congelado',
        'urlImagem': 'assets/images/frango.png',
        'unidade': 'kg',
        'price': 14.90,
      },
      {
        'id': 14,
        'name': 'Carne Bovina 1kg',
        'category': 'Carnes',
        'description': 'Carne bovina de primeira',
        'urlImagem': 'assets/images/carne.png',
        'unidade': 'kg',
        'price': 32.90,
      },

      // 🥦 Hortifruti
      {
        'id': 15,
        'name': 'Banana Prata 1kg',
        'category': 'Hortifruti',
        'description': 'Banana prata fresca',
        'urlImagem': 'assets/images/banana.png',
        'unidade': 'kg',
        'price': 5.50,
      },
      {
        'id': 16,
        'name': 'Tomate 1kg',
        'category': 'Hortifruti',
        'description': 'Tomate vermelho',
        'urlImagem': 'assets/images/tomate.png',
        'unidade': 'kg',
        'price': 6.00,
      },

      // 🧼 Limpeza
      {
        'id': 17,
        'name': 'Detergente Líquido 500ml',
        'category': 'Limpeza',
        'description': 'Detergente neutro',
        'urlImagem': 'assets/images/detergente.png',
        'unidade': 'ml',
        'price': 2.50,
      },
      {
        'id': 18,
        'name': 'Sabão em Pó 1kg',
        'category': 'Limpeza',
        'description': 'Sabão em pó para roupas',
        'urlImagem': 'assets/images/sabao.png',
        'unidade': 'kg',
        'price': 12.90,
      },

      // 🧴 Higiene
      {
        'id': 19,
        'name': 'Shampoo 400ml',
        'category': 'Higiene',
        'description': 'Shampoo hidratante',
        'urlImagem': 'assets/images/shampoo.png',
        'unidade': 'ml',
        'price': 11.90,
      },
      {
        'id': 20,
        'name': 'Sabonete 90g',
        'category': 'Higiene',
        'description': 'Sabonete perfumado',
        'urlImagem': 'assets/images/sabonete.png',
        'unidade': 'g',
        'price': 2.00,
      },

      // 🐶 Pet
      {
        'id': 21,
        'name': 'Ração para Cachorro 1kg',
        'category': 'Pet',
        'description': 'Ração seca para cães adultos',
        'urlImagem': 'assets/images/racao.png',
        'unidade': 'kg',
        'price': 12.00,
      },

      // 🍪 Snacks
      {
        'id': 22,
        'name': 'Biscoito Recheado 140g',
        'category': 'Snacks',
        'description': 'Biscoito sabor chocolate',
        'urlImagem': 'assets/images/biscoito.png',
        'unidade': 'g',
        'price': 3.50,
      },

      // 🧊 Congelados
      {
        'id': 23,
        'name': 'Pizza Congelada',
        'category': 'Congelados',
        'description': 'Pizza sabor calabresa',
        'urlImagem': 'assets/images/pizza.png',
        'unidade': 'un',
        'price': 18.90,
      },

      // 🧃 Bebidas (expandindo)
      {
        'id': 24,
        'name': 'Refrigerante Cola 2L',
        'category': 'Bebidas',
        'description': 'Refrigerante sabor cola',
        'urlImagem': 'assets/images/refri.png',
        'unidade': 'L',
        'price': 8.99,
      },
      {
        'id': 25,
        'name': 'Condicionador 400ml',
        'category': 'Beleza e Cabelo',
        'description': 'Condicionador hidratante',
        'urlImagem': 'assets/images/condicionador.png',
        'unidade': 'ml',
        'price': 13.90,
      },
      {
        'id': 26,
        'name': 'Creme para Pentear 300ml',
        'category': 'Beleza e Cabelo',
        'description': 'Creme para pentear cabelos cacheados',
        'urlImagem': 'assets/images/creme_pentear.png',
        'unidade': 'ml',
        'price': 15.50,
      },
      {
        'id': 27,
        'name': 'Gel Fixador 250g',
        'category': 'Beleza e Cabelo',
        'description': 'Gel fixador forte',
        'urlImagem': 'assets/images/gel.png',
        'unidade': 'g',
        'price': 7.90,
      },
      {
        'id': 28,
        'name': 'Tinta de Cabelo',
        'category': 'Beleza e Cabelo',
        'description': 'Coloração permanente',
        'urlImagem': 'assets/images/tinta.png',
        'unidade': 'un',
        'price': 19.90,
      },
      {
        'id': 29,
        'name': 'Óleo Capilar 100ml',
        'category': 'Beleza e Cabelo',
        'description': 'Óleo nutritivo para cabelos',
        'urlImagem': 'assets/images/oleo_capilar.png',
        'unidade': 'ml',
        'price': 18.00,
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
