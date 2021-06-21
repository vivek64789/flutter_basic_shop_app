import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopapp/models/http_exception.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final double price;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.price,
    this.isFavorite = false,
  });

  Future<void> toggleFavorite(String token) async {
    var _tempIsFavorite = isFavorite;
    // print("isFavorite: $isFavorite");
    // print("tempIsFavorite: $_tempIsFavorite");
    isFavorite = !isFavorite;
    notifyListeners();
    Uri url = Uri.parse(
      "https://shopapp-fc37d-default-rtdb.firebaseio.com/products/$id.json?auth=$token",
    );

    // print("$id, $title, $description, $price, $imageUrl");

    final response = await http.patch(
      url,
      body: json.encode(
        {
          "isFavorite": isFavorite,
        },
      ),
    );
    print(response.statusCode);
    if (response.statusCode >= 400 && isFavorite == true) {
      isFavorite = _tempIsFavorite;
      notifyListeners();
      throw HttpException("Failed to add $title as favorite");
    }
    if (response.statusCode >= 400 && isFavorite == false) {
      isFavorite = _tempIsFavorite;
      notifyListeners();
      throw HttpException("Failed to remove $title as favorite");
    }
    // print("isFavorite: $isFavorite");

    notifyListeners();
  }
}
