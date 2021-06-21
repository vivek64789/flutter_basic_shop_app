import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shopapp/providers/cart.dart';

import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final String dateTime;

  OrderItem(
      {required this.id,
      required this.amount,
      required this.products,
      required this.dateTime});
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  final String _token;

  Orders(this._token, this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> getSetOrders() async {
    Uri url = Uri.parse(
      "https://shopapp-fc37d-default-rtdb.firebaseio.com/orders.json?auth=$_token",
    );
    var response = await http.get(url);

    var extractedData = json.decode(response.body) as Map<String, dynamic>;

    final List<OrderItem> tempOrders = [];
    extractedData.forEach((orderId, orderData) {
      tempOrders.add(
        OrderItem(
          id: orderId,
          amount: orderData['amount'],
          products: (orderData['products'] as List<dynamic>).map((item) {
            return CartItem(
                id: item['id'],
                title: item['title'],
                price: item['price'],
                quantity: item['quantity'],
                imageUrl: item['imageUrl']);
          }).toList(),
          dateTime: DateTime.parse(orderData['dateTime']).toString(),
        ),
      );
    });

    _orders = tempOrders;

    notifyListeners();
  }

  Future<void> placeOrder(
      List<CartItem> placedProducts, double totalAmount) async {
    Uri url = Uri.parse(
      "https://shopapp-fc37d-default-rtdb.firebaseio.com/orders.json?auth=$_token",
    );

    final DateTime dateTime = DateTime.now();

    try {
      final _response = await http.post(url,
          body: json.encode({
            'amount': totalAmount,
            'products': placedProducts
                .map((e) => {
                      'id': e.id,
                      'title': e.title,
                      'quantity': e.quantity,
                      'price': e.price,
                      'imageUrl': e.imageUrl,
                    })
                .toList(),
            'dateTime': dateTime.toIso8601String(),
          }));

      _orders.insert(
        0,
        OrderItem(
          id: json.decode(_response.body)['name'],
          amount: totalAmount,
          products: placedProducts,
          dateTime: dateTime.toString(),
        ),
      );
    } catch (error) {
      print(error);
    }
  }
}
