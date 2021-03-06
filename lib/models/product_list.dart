import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shop/models/product.dart';
import 'package:shop/utils/constants.dart';

class ProductList with ChangeNotifier {
  final String _token;
  final String _userId;
  final List<Product> _items;
  ProductList([
    this._token = '',
    this._userId = '',
    this._items = const [],
  ]);

  final String _baseUrl = Constants.PRODUCTS_BASE_URL;

  List<Product> get favoriteItems =>
      _items.where((prodItem) => prodItem.isFavorite).toList();

  List<Product> get items {
    return [..._items];
  }

  int get itemCount {
    return _items.length;
  }

  Future<void> loadProducts() async {
    final http.Response response =
        await http.get(Uri.parse('$_baseUrl.json?auth=$_token'));
    if (response.body == 'null') return;

    final favResponse = await http.get(
      Uri.parse('$_baseUrl/$_userId.json?auth=$_token'),
    );

    final Map<String, dynamic> favData =
        favResponse.body == 'null' ? {} : json.decode(favResponse.body);

    Map<String, dynamic> data = jsonDecode(response.body);
    _items.clear();
    data.forEach((productId, value) {
      final isFavorite = favData[productId] ?? false;
      _items.add(
        Product(
          id: productId,
          name: value['name'],
          description: value['description'],
          price: value['price'],
          imageUrl: value['imageUrl'],
          isFavorite: isFavorite,
        ),
      );
    });
  }

  Future<void> addProduct(Product product) async {
    final http.Response response =
        await http.post(Uri.parse('$_baseUrl.json?auth=$_token'),
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
    );

    _items.add(newProduct);
    notifyListeners();
  }

  Future<void> updateProduct(Product product) async {
    final index = _items.indexWhere((prod) => prod.id == product.id);
    if (index >= 0) {
      await http.patch(
        Uri.parse('$_baseUrl/${product.id}.json?auth=$_token'),
        body: jsonEncode({
          'name': product.name,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
        }),
      );

      _items[index] = product;
      notifyListeners();
    }
  }

  Future<void> removeProduct(String id) async {
    final index = _items.indexWhere((prod) => prod.id == id);
    if (index >= 0) {
      final url = Uri.parse('$_baseUrl/$id.json?auth=$_token');
      final response = await http.delete(url);
      if (response.statusCode >= 400) {
        throw Exception('Failed to delete product');
      }
      _items.removeAt(index);
      notifyListeners();
    }

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
      await updateProduct(newProduct);
    } else {
      await addProduct(newProduct);
    }
  }
}
