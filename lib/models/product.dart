import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final double price;
  bool isFavorite;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.price,
    this.isFavorite = false,
  });

  Future<void> toggleFavorite() async {
    const String _baseUrl =
        'https://shop-7706e-default-rtdb.firebaseio.com/products';
    await http.patch(
      Uri.parse('$_baseUrl/$id.json'),
      body: jsonEncode({
        'isFavorite': !isFavorite,
      }),
    );
    isFavorite = !isFavorite;
    notifyListeners();
  }
}
