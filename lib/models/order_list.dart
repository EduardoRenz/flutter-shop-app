import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shop/models/cart_item.dart';
import 'package:shop/models/order.dart';
import 'package:http/http.dart' as http;
import 'package:shop/models/product.dart';
import '../utils/constants.dart';
import 'cart.dart';

class OrderList with ChangeNotifier {
  final List<Order> _orders = [];

  List<Order> get orders {
    return [..._orders];
  }

  Future<void> addOrder(Cart cart) async {
    final date = DateTime.now();

    final http.Response response = await http.post(
      Uri.parse('${Constants.ORDERS_BASE_URL}.json'),
      body: jsonEncode({
        'total': cart.totalAmount,
        'date': date.toIso8601String(),
        'products': cart.items.values
            .map((item) => {
                  'id': item.id,
                  'productId': item.productId,
                  'name': item.name,
                  'quantity': item.quantity,
                  'price': item.price,
                  'imageUrl': item.imageUrl,
                })
            .toList(),
      }),
    );

    final id = json.decode(response.body)['name'];

    Order newOrder = Order(
      id: id,
      total: cart.totalAmount,
      products: cart.items.values.toList(),
      date: date,
    );

    _orders.insert(0, newOrder);
    notifyListeners();
  }

  Future<void> loadOrders() async {
    _orders.clear();
    final http.Response response =
        await http.get(Uri.parse('${Constants.ORDERS_BASE_URL}.json'));
    if (response.body == 'null') return;
    Map<String, dynamic> data = jsonDecode(response.body);

    data.forEach((id, order) {
      _orders.add(
        Order(
            id: id,
            total: order['total'],
            date: DateTime.parse(order['date']),
            products: (order['products'] as List<dynamic>)
                .map((product) => CartItem(
                    id: id,
                    productId: product['productId'],
                    name: product['name'],
                    quantity: product['quantity'],
                    price: product['price'],
                    imageUrl: product['imageUrl']))
                .toList()),
      );
    });

    notifyListeners();
  }
}
