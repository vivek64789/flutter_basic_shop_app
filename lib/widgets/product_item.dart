import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/cart.dart';
import 'package:shopapp/providers/product.dart';
import 'package:shopapp/screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context);
    /*
    final providerData = Provider.of<Product>(context); 
    */
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: GridTile(
        child: GestureDetector(
          onTap: () => {
            Navigator.pushNamed(context, ProductDetailScreen.routeName,
                arguments: product.id),
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black.withOpacity(0.5),
          leading: Consumer<Product>(
            builder: (_, product, child) => IconButton(
              icon: Icon(
                product.isFavorite ? Icons.favorite : Icons.favorite_outline,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: () {
                product.toggleFavorite();
              },
            ),
          ),
          title: Text(
            product.title,
            style: TextStyle(fontFamily: 'Poppins'),
            softWrap: true,
            overflow: TextOverflow.clip,
          ),
          trailing: Consumer<Cart>(
            builder: (_, cart, child) => IconButton(
              icon: cart.checkItemInCart(product.id)
                  ? Icon(
                      Icons.shopping_cart,
                      color: Theme.of(context).accentColor,
                    )
                  : Icon(
                      Icons.shopping_cart_outlined,
                      color: Theme.of(context).accentColor,
                    ),
              onPressed: () => {
                cart.toggleCartItem(
                  product.id,
                  product.title,
                  product.price,
                  product.imageUrl,
                ),
              },
            ),
          ),
        ),
      ),
    );
  }
}
