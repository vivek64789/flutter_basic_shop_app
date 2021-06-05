import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/product.dart';
import 'package:shopapp/providers/products.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product-details';
  const ProductDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final Product product =
        Provider.of<Products>(context).getProductById(productId);
    return Scaffold(
        appBar: AppBar(
          title: Text("${product.title}"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                child: Image.network(product.imageUrl),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Rs.${product.price}',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 20,
              ),
              Card(
                margin: EdgeInsets.all(10),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  width: double.infinity,
                  child: Text(
                    product.description,
                    style: TextStyle(
                      fontSize: 18,
                    ),
                    softWrap: true,
                  ),
                  alignment: Alignment.center,
                ),
              )
            ],
          ),
        ));
  }
}
