import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:shop/models/product.dart';
import 'cart_item.dart';

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }

  void addItem(Product product) {
    if (_items.containsKey(product.id)) {
      _items.update(
          product.id,
          (existingCartItem) => CartItem(
              id: existingCartItem.id,
              productId: existingCartItem.productId,
              name: existingCartItem.name,
              price: existingCartItem.price,
              quantity: existingCartItem.quantity + 1,
              imageUrl: existingCartItem.imageUrl));
    } else {
      _items.putIfAbsent(
          product.id,
          () => CartItem(
              id: Random().nextDouble().toString(),
              productId: product.id,
              name: product.name,
              price: product.price,
              quantity: 1,
              imageUrl: product.imageUrl));
    }
    notifyListeners();
  }
}
