import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../../../app/core/storage/hive_boxes.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final box = Hive.box(HiveBoxes.orders);
    final orders = box.values.whereType<Map>().toList().reversed.toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Meus pedidos')),
      body: orders.isEmpty
          ? const Center(child: Text('Você ainda não possui pedidos.'))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: orders.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, index) {
                final order = Map<String, dynamic>.from(orders[index]);
                final total = (order['total'] as num?)?.toDouble() ?? 0;
                return Card(
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: const CircleAvatar(child: Icon(Icons.receipt_long_outlined)),
                    title: Text('Pedido ${order['id'] ?? '---'}', maxLines: 1, overflow: TextOverflow.ellipsis),
                    subtitle: Text('${(order['itens'] as List?)?.length ?? 0} itens'),
                    trailing: Text('R\$ ${total.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.w800)),
                  ),
                );
              },
            ),
    );
  }
}
