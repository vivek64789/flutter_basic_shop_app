import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/cart.dart' show Cart;
import 'package:shopapp/providers/orders.dart';
import '../widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final itemProvider = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Cart"),
      ),
      body: Column(
        children: [
          Card(
            elevation: 10,
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                    "Total",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  Spacer(),
                  Chip(
                    backgroundColor: Theme.of(context).primaryColor,
                    labelStyle: TextStyle(
                      color: Colors.white,
                    ),
                    label: Text('Rs ${itemProvider.totalCartAmount}'),
                  ),
                  TextButton(
                    onPressed: () {
                      Provider.of<Orders>(context, listen: false).placeOrder(
                        itemProvider.items.values.toList(),
                        double.parse(itemProvider.totalCartAmount),
                      );
                      itemProvider.clearAllItems();
                    },
                    child: Text(
                      "Order Now",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      itemProvider.clearAllItems();
                    },
                    icon: itemProvider.checkIfCartEmpty
                        ? Icon(
                            Icons.delete_outline,
                            color: Theme.of(context).primaryColor,
                          )
                        : Icon(
                            Icons.delete,
                            color: Theme.of(context).primaryColor,
                          ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
              child: ListView.builder(
            itemCount: itemProvider.items.length,
            itemBuilder: (context, index) {
              return CartItem(
                productId: itemProvider.items.keys.toList()[index],
                id: itemProvider.items.values.toList()[index].id,
                price: itemProvider.items.values.toList()[index].price,
                quantity: itemProvider.items.values.toList()[index].quantity,
                title: itemProvider.items.values.toList()[index].title,
                imageUrl: itemProvider.items.values.toList()[index].imageUrl,
              );
            },
          ))
        ],
      ),
    );
  }
}
