import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/cart.dart';
import 'package:shopapp/screens/cart_screen.dart';
import 'package:shopapp/widgets/badge.dart';
import 'package:shopapp/widgets/drawer.dart';
import 'package:shopapp/widgets/product_grid.dart';

enum filters {
  onlyFavorites,
  allProducts,
}

class ProductsOverView extends StatefulWidget {
  static const routeName = '/products';
  ProductsOverView({Key? key}) : super(key: key);

  @override
  _ProductsOverViewState createState() => _ProductsOverViewState();
}

class _ProductsOverViewState extends State<ProductsOverView> {
  bool _isProductFavorite = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer:  DrawerWidget(),
      appBar: AppBar(
        title: Text("Products"),
        actions: [
          PopupMenuButton(
            onSelected: (selectedFilter) {
              setState(() {
                if (selectedFilter == filters.onlyFavorites) {
                  _isProductFavorite = true;
                } else {
                  _isProductFavorite = false;
                }
              });
            },
            elevation: 15,
            tooltip: "Choose Filters",
            itemBuilder: (ctx) => [
              PopupMenuItem(
                child: Text("All Favorites"),
                value: filters.onlyFavorites,
              ),
              PopupMenuItem(
                child: Text("All"),
                value: filters.allProducts,
              ),
            ],
            icon: Icon(Icons.more_vert),
          ),
          Consumer<Cart>(
            builder: (_, cart, _1) => Badge(
              child: IconButton(
                icon: cart.checkIfCartEmpty
                    ? Icon(Icons.shopping_cart_outlined)
                    : Icon(Icons.shopping_cart),
                onPressed: () => {
                  Navigator.of(context).pushNamed(CartScreen.routeName),
                },
              ),
              value: cart.cartItemCounts.toString(),
              color: Theme.of(context).accentColor,
            ),
          ),
        ],
      ),
      body: ProductGrid(_isProductFavorite),
    );
  }
}



// 186