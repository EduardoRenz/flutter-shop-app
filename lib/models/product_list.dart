import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shop/data/dummy_data.dart';
import 'package:shop/models/product.dart';

class ProductList with ChangeNotifier {
  final _baseURL = 'https://shop-7706e-default-rtdb.firebaseio.com';
  final List<Product> _items = dummyProducts;

  List<Product> get favoriteItems =>
      _items.where((prodItem) => prodItem.isFavorite).toList();

  List<Product> get items {
    return [..._items];
  }

  int get itemCount {
    return _items.length;
  }

  Future<void> addProduct(Product product) async {
    final http.Response response =
        await http.post(Uri.parse('$_baseURL/products.json'),
            body: jsonEncode({
              'name': product.name,
              'description': product.description,
              'imageUrl': product.imageUrl,
              'price': product.price,
              'isFavorite': product.isFavorite,
            }));

    final id = json.decode(response.body)['name'];
    final newProduct = Product(
      id: id,
      name: product.name,
      description: product.description,
      price: product.price,
      imageUrl: product.imageUrl,
      isFavorite: product.isFavorite,
    );

    _items.add(newProduct);
    notifyListeners();
  }

  void updateProduct(Product product) {
    final index = _items.indexWhere((prod) => prod.id == product.id);
    if (index >= 0) {
      _items[index] = product;
      notifyListeners();
    }
  }

  void removeProduct(String id) {
    _items.removeWhere((prod) => prod.id == id);
    notifyListeners();
  }

  Future<void> saveProduct(Map<String, Object> data) async {
    final bool hasId = data['id'] != null;

    final Product newProduct = Product(
      id: hasId ? data['id'] as String : Random().nextDouble().toString(),
      name: data['name'] as String,
      description: data['description'] as String,
      price: data['price'] as double,
      imageUrl: data['imageUrl'] as String,
    );

    if (hasId) {
      updateProduct(newProduct);
    } else {
      await addProduct(newProduct);
    }
  }
}
