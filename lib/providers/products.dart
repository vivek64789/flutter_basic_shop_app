import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:shopapp/models/http_exception.dart';
import 'package:shopapp/providers/product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
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
    return [..._items]; // where here copying the original _items
    //so that if its accessed we are not passign the references of our items
  }

  List<Product> get getFavoritesItem {
    return _items.where((product) => product.isFavorite).toList();
  }

  Product getProductById(String id) {
    return _items.firstWhere((product) => product.id == id);
  }

  Future<void> fetchAndSetProducts() async {
    Uri url = Uri.parse(
      "https://shopapp-fc37d-default-rtdb.firebaseio.com/products.json",
    );
    try {
      final response = await http.get(url);
      final responseData = json.decode(response.body) as Map<String, dynamic>;
      responseData.forEach((key, value) {
        final List<Product> _tempProduct = [];
        _tempProduct.insert(
          0,
          Product(
            id: key,
            title: value['title'],
            description: value["description"],
            imageUrl: value['imageUrl'],
            price: value['price'],
            isFavorite: value['isFavorite'],
          ),
        );
        _items = _tempProduct;
      });
    } catch (error) {
      print(error);
    }
    notifyListeners();
  }

  Future<void> addProduct(Product product) async {
    try {
      Uri url = Uri.parse(
          "https://shopapp-fc37d-default-rtdb.firebaseio.com/products.json");
      var response = await http.post(
        url,
        body: json.encode(
          {
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
            'isFavorite': product.isFavorite,
          },
        ),
      );
      final tempProduct = Product(
          id: json.decode(response.body)['name'],
          title: product.title,
          description: product.description,
          imageUrl: product.imageUrl,
          price: product.price);

      _items.add(tempProduct);
      notifyListeners(); // this will notify that our data is updated and it will
      //rebuild the widgets that listens to this notifier

    } catch (error) {
      print(error.toString());
      throw error;
    }
  }

  Future<void> removeItem(String productId) async {
    Uri url = Uri.parse(
        "https://shopapp-fc37d-default-rtdb.firebaseio.com/products/$productId.json");

    final index = _items.indexWhere((item) => item.id == productId);
    var _copiedProduct = _items[index];
    _items.removeAt(index);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(index, _copiedProduct);
      notifyListeners();
      throw HttpException("Failed to delete product");
    } else {
      _copiedProduct.dispose();
      print("copeid product $_copiedProduct");
    }
  }

  Future<void> updateProduct(String id, Product editedProduct) async {
    final index = _items.indexWhere((product) => product.id == id);
    Uri url = Uri.parse(
        "https://shopapp-fc37d-default-rtdb.firebaseio.com/products/$id.json");
    if (index >= 0) {
      await http.patch(
        url,
        body: json.encode(
          {
            'title': editedProduct.title,
            'price': editedProduct.price,
            'description': editedProduct.description,
            'imageUrl': editedProduct.imageUrl,
          },
        ),
      );

      _items[index] = editedProduct;
    }

    notifyListeners();
  }
}
