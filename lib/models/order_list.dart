import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:shop/models/order.dart';

import 'cart.dart';

class OrderList with ChangeNotifier {
  final List<Order> _orders = [];

  List<Order> get orders {
    return [..._orders];
  }

  void addOrder(Cart cart) {
    Order newOrder = Order(
      id: Random().nextDouble().toString(),
      total: cart.totalAmount,
      products: cart.items.values.toList(),
      date: DateTime.now(),
    );

    _orders.insert(0, newOrder);
    notifyListeners();
  }
}
