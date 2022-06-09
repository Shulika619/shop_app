import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product(
      {required this.id,
      required this.title,
      required this.description,
      required this.price,
      required this.imageUrl,
      this.isFavorite = false});

  Future<void> toggleFavoriteStatus(String authToken, String userId) async {
    final url = Uri.parse(
        'https://developer-shulika-test-default-rtdb.europe-west1.firebasedatabase.app/userFavorites/$userId/$id.json?auth=$authToken');
    try {
      final response = await http.put(url, body: jsonEncode(!isFavorite));
      isFavorite = !isFavorite;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
