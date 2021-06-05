import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/products.dart';
import 'package:shopapp/widgets/product_item.dart';

class ProductGrid extends StatelessWidget {
  final bool isProductFavoriteOnly;

  ProductGrid(this.isProductFavoriteOnly);
  @override
  Widget build(BuildContext context) {
    print(isProductFavoriteOnly);
    final providerData = Provider.of<Products>(context);
    final allProducts = isProductFavoriteOnly
        ? providerData.getFavoritesItem
        : providerData.items;
    return GridView.builder(
        padding: EdgeInsets.all(10),
        itemCount: allProducts.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 2 / 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (context, index) {
          return ChangeNotifierProvider.value(
            value: allProducts[index],
            child: ProductItem(),
          );
        });
  }
}
