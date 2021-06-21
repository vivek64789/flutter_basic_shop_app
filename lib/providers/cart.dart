import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CartItem {
  String id;
  String title;
  double price;
  int quantity;
  String imageUrl;

  CartItem({
    required this.id,
    required this.title,
    required this.price,
    required this.quantity,
    required this.imageUrl,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get cartItemCounts {
    return _items.length;
  }

  String get totalCartAmount {
    double total = 0.0;

    _items.forEach((key, cart) {
      total += cart.price * cart.quantity;
    });
    return total.toStringAsFixed(2);
  }

  bool checkItemInCart(String productId) {
    return _items.containsKey(productId);
  }

  void clearAllItems() {
    _items.clear();
    notifyListeners();
  }

  bool get checkIfCartEmpty {
    return _items.isEmpty;
  }

  void toggleCartItem(String productId, String title, double price,
      String imageUrl, String token) async {
    Uri getPostUrl = Uri.parse(
      "https://shopapp-fc37d-default-rtdb.firebaseio.com/cart.json?auth=$token",
    );
    String itemId = '';
    _items.forEach((key, cartItem) {
      itemId = _items[key]!.id;
    });
    print("object $itemId");
    Uri deleteUrl = Uri.parse(
      "https://shopapp-fc37d-default-rtdb.firebaseio.com/cart/$itemId.json?auth=$token",
    );
    itemId = '';
    if (_items.containsKey(productId)) {
      _items.removeWhere((itemId, cartItem) => itemId == productId);
      http.delete(deleteUrl);
    } else {
      final _response = await http.post(getPostUrl,
          body: (json.encode({
            'title': title,
            'price': price,
            'quantity': 1,
            'imageUrl': imageUrl,
          })));

      var _responseData = json.decode(_response.body) as Map<String, dynamic>;

      _items.putIfAbsent(
        productId,
        () => CartItem(
            id: _responseData['name'],
            title: title,
            price: price,
            quantity: 1,
            imageUrl: imageUrl),
      );
    }
    notifyListeners();
  }

  void deleteCartItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void increaseCartItem(
      String productId, String title, double price, String imageUrl) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (existingItem) => CartItem(
            id: existingItem.id,
            title: existingItem.title,
            price: existingItem.price,
            quantity: existingItem.quantity + 1,
            imageUrl: existingItem.imageUrl),
      );
    }
    notifyListeners();
  }

  void decreaseCartItem(
      String productId, String title, double price, String imageUrl) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (existingItem) => CartItem(
            id: existingItem.id,
            title: existingItem.title,
            price: existingItem.price,
            quantity: existingItem.quantity < 2
                ? existingItem.quantity - 0
                : existingItem.quantity - 1,
            imageUrl: existingItem.imageUrl),
      );
    }
    notifyListeners();
  }
}
