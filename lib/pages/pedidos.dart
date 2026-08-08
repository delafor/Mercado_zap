import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class PedidosPage extends StatefulWidget {
  const PedidosPage({super.key});

  @override
  State<PedidosPage> createState() => _PedidosPageState();
}

class _PedidosPageState extends State<PedidosPage> {
  @override
  Widget build(BuildContext context) {
    final pedidosBox = Hive.box('pedidos');

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),

      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F9FC),
        elevation: 0,
        title: const Text(
          'Meus Pedidos',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 25,
            color: Color(0xFF181B19),
          ),
        ),
      ),

      body: ValueListenableBuilder(
        valueListenable: pedidosBox.listenable(),

        builder: (context, Box box, _) {
          if (box.length == 0) {
            return const Center(child: Text('Nenhum pedido encontrado'));
          }

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(14, 4, 14, 24),
            itemCount: box.length,

            itemBuilder: (context, index) {
              final pedidos = Map<String, dynamic>.from(box.getAt(index));

              return _PedidoCard(pedidos: pedidos);
            },
          );
        },
      ),
    );
  }
}

class _PedidoCard extends StatelessWidget {
  final Map<String, dynamic> pedidos;

  const _PedidoCard({required this.pedidos});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE3E5E8)),
      ),

      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 16, 14, 14),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            // ENDEREÇO
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  size: 18,
                  color: Color(0xFF53B175),
                ),

                const SizedBox(width: 7),

                Expanded(
                  child: Text(
                    pedidos['endereco']?.toString() ?? '',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF59605C),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // TELEFONE
            Row(
              children: [
                const Icon(
                  Icons.phone_outlined,
                  size: 18,
                  color: Color(0xFF53B175),
                ),

                const SizedBox(width: 7),

                Text(
                  pedidos['telefone']?.toString() ?? '',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF59605C),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // TOTAL VERDE
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),

              decoration: BoxDecoration(
                color: const Color(0xFFE4F6E9),
                borderRadius: BorderRadius.circular(30),
              ),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.account_balance_wallet_outlined,
                        size: 18,
                        color: Color(0xFF238B45),
                      ),

                      const SizedBox(width: 8),

                      const Text(
                        'Total do pedido',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF238B45),
                        ),
                      ),
                    ],
                  ),

                  Text(
                    'R\$ ${pedidos['total'] ?? 0}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF238B45),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // STATUS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'PRODUTOS',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: .4,
                    color: Color(0xFF68706B),
                  ),
                ),

                Text(
                  pedidos['status']?.toString() ?? '',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF53B175),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 4),

            // PRODUTOS
            ...(pedidos['itens'] as List? ?? []).map((item) {
              final produto = Map<String, dynamic>.from(item);

              final quantidade = produto['quantity'] as num;
              final precoUnitario = produto['price'] as num;

              final totalProduto = quantidade * precoUnitario;

              return Container(
                padding: const EdgeInsets.symmetric(vertical: 13),

                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: Color(0xFFE1E3E6))),
                ),

                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            produto['name']?.toString() ?? '',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF181B19),
                            ),
                          ),

                          const SizedBox(height: 4),

                          Text(
                            '$quantidade x R\$ ${precoUnitario.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF7A817C),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Text(
                      'R\$ ${totalProduto.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF181B19),
                      ),
                    ),
                  ],
                ),
              );
            }),

            const SizedBox(height: 14),

            // TOTAL FINAL
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                const Text(
                  'Total do pedido',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF181B19),
                  ),
                ),

                Text(
                  'R\$ ${((pedidos['total'] ?? 0) as num).toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF53B175),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
