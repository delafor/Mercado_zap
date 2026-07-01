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
      appBar: AppBar(title: const Text('Meus Pedidos')),
      body: ValueListenableBuilder(
        valueListenable: pedidosBox.listenable(),
        builder: (context, Box box, _) {
          if (box.length == 0) {
            return const Center(child: Text('Nenhum pedido encontrado'));
          }

          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final pedidos = Map<String, dynamic>.from(box.getAt(index));

              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  title: Text(pedidos['nome']?.toString() ?? ''),

                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(pedidos['endereco']?.toString() ?? ''),
                      Text('Telefone: ${pedidos['telefone'] ?? ''}'),
                      const SizedBox(height: 8),
                      Text('Total: R\$ ${pedidos['total'] ?? 0}'),
                      const SizedBox(height: 8),
                      Text('---------pedidos abaixo-----------'),
                      const SizedBox(height: 8),
                      const Text('Produtos:'),

                      ...(pedidos['itens'] as List? ?? []).map((item) {
                        final produto = Map<String, dynamic>.from(item);

                        final quantidade = produto['quantity'] as num;
                        final precoUnitario = produto['price'] as num;

                        final totalProduto = quantidade * precoUnitario;

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text('$quantidade x ${produto['name']}'),
                              ),

                              Text('R\$ ${totalProduto.toStringAsFixed(2)}'),
                              const Divider(),
                            ],
                          ),
                        );
                      }),
                      const Divider(),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'Total do Pedido: R\$ ${((pedidos['total'] ?? 0) as num).toStringAsFixed(2)}',
                        ),
                      ),
                    ],
                  ),
                  trailing: Text(pedidos['status']?.toString() ?? ''),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
