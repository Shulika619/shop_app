import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime datetime;
  OrderItem({
    required this.id,
    required this.amount,
    required this.products,
    required this.datetime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    const url =
        'https://developer-shulika-test-default-rtdb.europe-west1.firebasedatabase.app/orders.json';
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200 && response.body.toString() != 'null') {
        List<OrderItem> loadedOrders = [];
        final extractedData = jsonDecode(response.body) as Map<String, dynamic>;
        extractedData.forEach((orderId, orderData) {
          loadedOrders.add(OrderItem(
              id: orderId,
              amount: orderData['amount'],
              products: (orderData['products'] as List<dynamic>)
                  .map((item) => CartItem(
                      id: item['id'],
                      title: item['title'],
                      quantity: item['quantity'],
                      price: item['price']))
                  .toList(),
              datetime: DateTime.parse(orderData['datetime'])));
        });
        _orders = loadedOrders.reversed.toList();
        notifyListeners();
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    const url =
        'https://developer-shulika-test-default-rtdb.europe-west1.firebasedatabase.app/orders.json';
    final _dateTimeNow = DateTime.now();
    try {
      final response = await http.post(Uri.parse(url),
          body: jsonEncode({
            'amount': total,
            'datetime': _dateTimeNow.toIso8601String(),
            'products': cartProducts
                .map((cartP) => {
                      'id': cartP.id,
                      'title': cartP.title,
                      'quantity': cartP.quantity,
                      'price': cartP.price
                    })
                .toList()
          }));
      _orders.insert(
          0,
          OrderItem(
              id: jsonDecode(response.body)['name'],
              amount: total,
              products: cartProducts,
              datetime: _dateTimeNow));
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
