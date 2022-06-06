import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';
import 'product.dart';

const kUrl =
    'https://developer-shulika-test-default-rtdb.europe-west1.firebasedatabase.app/pruducts.json';

class ProductsProvider with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //     id: 'p1',
    //     title: 'Red Shirt',
    //     description: 'A red shirt - it is pretty red!',
    //     price: 29.99,
    //     imageUrl:
    //         'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg'),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return items.where((prod) => prod.isFavorite).toList();
  }

  Future<void> fetchAndSetProducts() async {
    try {
      final response = await http.get(Uri.parse(kUrl));
      if (response.statusCode == 200 && response.body.toString() != 'null') {
        final extractedData = jsonDecode(response.body) as Map<String, dynamic>;
        final List<Product> loadedProducts = [];
        extractedData.forEach((prodId, prodData) {
          loadedProducts.add(Product(
              id: prodId,
              title: prodData['title'],
              description: prodData['description'],
              price: prodData['price'],
              imageUrl: prodData['imageUrl'],
              isFavorite: prodData['isFavorite']));
        });
        _items = loadedProducts;
        notifyListeners();
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addProduct(Product newProduct) async {
    try {
      final url = Uri.parse(kUrl);
      final response = await http.post(url,
          body: jsonEncode({
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price,
            'isFavorite': newProduct.isFavorite,
          }));
      final product = Product(
          id: jsonDecode(response.body)['name'],
          title: newProduct.title,
          description: newProduct.description,
          price: newProduct.price,
          imageUrl: newProduct.imageUrl);
      _items.add(product);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateProduct(Product newProduct) async {
    final url =
        'https://developer-shulika-test-default-rtdb.europe-west1.firebasedatabase.app/pruducts/${newProduct.id}.json';
    try {
      await http.patch(Uri.parse(url),
          body: jsonEncode({
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price,
            // 'isFavorite': newProduct.isFavorite,
          }));
      final productIndex =
          _items.indexWhere((prod) => prod.id == newProduct.id);
      _items[productIndex] = newProduct;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> removeProduct(String id) async {
    final url =
        'https://developer-shulika-test-default-rtdb.europe-west1.firebasedatabase.app/pruducts/$id.json';
    try {
      final response =
          await http.delete(Uri.parse(url)).timeout(const Duration(seconds: 3));
      if (response.statusCode == 200) {
        _items.removeWhere((prod) => prod.id == id);
        notifyListeners();
      } else {
        throw HttpException('Error response? Cant delete product!');
      }
    } on TimeoutException catch (_) {
      rethrow;
    } catch (error) {
      rethrow;
    }
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }
}
