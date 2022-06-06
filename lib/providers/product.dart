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

  Future<void> toggleFavoriteStatus() async {
    final url =
        'https://developer-shulika-test-default-rtdb.europe-west1.firebasedatabase.app/pruducts/$id.json';
    try {
      final response = await http.patch(Uri.parse(url),
          body: jsonEncode({'isFavorite': !isFavorite}));
      isFavorite = !isFavorite;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
