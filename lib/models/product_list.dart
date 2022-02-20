import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:shop/data/dummy_data.dart';
import 'package:shop/models/product.dart';

class ProductList with ChangeNotifier {
  final List<Product> _items = dummyProducts;

  List<Product> get favoriteItems =>
      _items.where((prodItem) => prodItem.isFavorite).toList();

  List<Product> get items {
    return [..._items];
  }

  int get itemCount {
    return _items.length;
  }

  void addProduct(Product product) {
    _items.add(product);
    notifyListeners();
  }

  void addProductFromData(Map<String, Object> data) {
    final Product newProduct = Product(
      id: Random().nextDouble().toString(),
      name: data['name'] as String,
      description: data['description'] as String,
      price: data['price'] as double,
      imageUrl: data['imageUrl'] as String,
    );
    _items.add(newProduct);
    notifyListeners();
  }
}
