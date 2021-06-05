import 'package:flutter/material.dart';

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

  void toggleCartItem(
      String productId, String title, double price, String imageUrl) {
    if (_items.containsKey(productId)) {
      _items.removeWhere((itemId, cartItem) => itemId == productId);
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItem(
            id: DateTime.now().toString(),
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
