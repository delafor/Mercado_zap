import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:mercado_zap/models/cart_item.dart';
import 'package:mercado_zap/models/order.dart';

class OrderProvider with ChangeNotifier {
    final Box _box = Hive.box('appBox');

    final List<Order> _orders = [];
}