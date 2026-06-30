import 'package:flutter/material.dart';
import 'package:mercado_zap/Payments/checkout_payment_page.dart';
import 'package:mercado_zap/models/cart_item.dart';
import 'package:mercado_zap/models/product.dart';

import 'package:mercado_zap/providers/cart_provider.dart';
import 'package:mercado_zap/widgets/counter.dart';
import 'package:provider/provider.dart';

class ProductSheet extends StatefulWidget {
  final Product product;
  final ScrollController scrollController;

  const ProductSheet({
    super.key,
    required this.product,
    required this.scrollController,
  });

  @override
  State<ProductSheet> createState() => _ProductSheetState();
}

class _ProductSheetState extends State<ProductSheet> {
  int quantity = 1;

  void increase() {
    setState(() {
      quantity++;
    });
  }

  void decrease() {
    if (quantity > 1) {
      setState(() {
        quantity--;
      });
    }
  }

  double get subtotal {
    return widget.product.price * quantity;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        controller: widget.scrollController, // 
        children: [
          // puxador
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 50,
              height: 5,
              margin: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),

          const SizedBox(height: 10),

          Image.asset(
            widget.product.urlImagem ?? '',
            height: 150,
            fit: BoxFit.contain,

            errorBuilder: (_, __, ___) {
              return const Icon(Icons.image_not_supported, size: 80);
            },
          ),

          const SizedBox(height: 15),

          Text(
            widget.product.name,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 10),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'R\$ ${widget.product.price}/ ${widget.product.unidade}',

                style: TextStyle(
                  color: colors.secondary,
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Quantidade',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
              ),
            ],
          ),
          CounterWidget(
            counter: quantity,
            onIncrease: increase,
            onDecrease: decrease,
          ),

          Divider(thickness: 1, color: Colors.grey),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'SubTotal',

                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                ),

                Text(
                  'R\$ ${(widget.product.price * quantity).toStringAsFixed(2)}',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    final cartItem = CartItem.fromProduct(
                      widget.product,
                      quantity: quantity,
                    );
                    context.read<CartProvider>().adicionarItem(cartItem);
                    setState(() {
                      quantity = 1;
                    });
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 60),
                    foregroundColor: colors.onSecondary,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),

                      side: BorderSide(color: colors.secondary),
                    ),

                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  child: Text(
                    'Adicionar ao carrinho',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: colors.secondary,
                    ),
                  ),
                ),
                SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => CheckoutPaymentPage(
                              total: widget.product.price * quantity,

                              produtos: [
                                CartItem(
                                  productId: widget.product.id,
                                  name: widget.product.name,
                                  price: widget.product.price,
                                  quantity: quantity,
                                  id: '',
                                ),
                              ],
                            ),
                      ),
                    );
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.secondary,
                    minimumSize: const Size(double.infinity, 60),
                    foregroundColor: colors.onSecondary,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),

                      side: BorderSide(color: colors.secondary),
                    ),

                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  child: Text(
                    'Comprar agora',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: colors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void openProductSheet(BuildContext context, Product product) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return DraggableScrollableSheet(
        initialChildSize: 0.6, 
        minChildSize: 0.4, 
        maxChildSize: 0.6, 
        expand: false,
        builder: (_, controller) {
          return ProductSheet(product: product, scrollController: controller);
        },
      );
    },
  );
}
