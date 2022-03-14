import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shop/utils/constants.dart';

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

  Future<void> toggleFavorite(String token, String userId) async {
    const String _baseUrl = Constants.USER_FAVORITES;
    await http.put(
      Uri.parse('$_baseUrl/$userId/$id.json?auth=$token'),
      body: jsonEncode(!isFavorite),
    );
    isFavorite = !isFavorite;
    notifyListeners();
  }
}
