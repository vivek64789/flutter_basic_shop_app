import 'package:flutter/material.dart';
import 'package:shopapp/providers/product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
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

  void addProduct(Product product) {
    final tempProduct = Product(
        id: DateTime.now().toString(),
        title: product.title,
        description: product.description,
        imageUrl: product.imageUrl,
        price: product.price);

    _items.add(tempProduct);
    notifyListeners(); // this will notify that our data is updated and it will
    //rebuild the widgets that listens to this notifier
  }

  removeItem(String productId) {
    _items.removeWhere((item) => item.id == productId);
    notifyListeners();
  }

  void updateProduct(String id, Product editedProduct) {
    final index = _items.indexWhere((item) => item.id == id);
    _items[index] = editedProduct;
    notifyListeners();
  }
}
