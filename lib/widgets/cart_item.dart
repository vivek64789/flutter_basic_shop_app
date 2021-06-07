import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/cart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String title;
  final double price;
  final int quantity;
  final String imageUrl;
  final String productId;
  CartItem(
      {Key? key,
      required this.id,
      required this.productId,
      required this.title,
      required this.price,
      required this.quantity,
      required this.imageUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final itemProvider = Provider.of<Cart>(context, listen: false);
    return Dismissible(
      key: ValueKey(id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Are you sure?"),
                content:
                    Text("Do you want to remove this item from your cart?"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: Text("Yes"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: Text("No"),
                  ),
                ],
              );
            });
      },
      onDismissed: (direction) {
        itemProvider.deleteCartItem(productId);
      },
      background: Container(
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        color: Theme.of(context).errorColor,
        alignment: Alignment.centerRight,
        child: Icon(
          Icons.delete,
          size: 30,
          color: Colors.white,
        ),
      ),
      child: Container(
        height: 150,
        child: Card(
          elevation: 8,
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
            children: [
              Container(
                width: 100,
                child: Card(
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  Text(
                    "Total Price: ${(price * quantity).toStringAsFixed(2)}",
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    "Total Items: ${quantity}x",
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.all(10),
                child: Column(children: [
                  IconButton(
                    onPressed: () {
                      itemProvider.increaseCartItem(
                          productId, title, price, imageUrl);
                    },
                    icon: Icon(Icons.add),
                  ),
                  IconButton(
                    onPressed: () {
                      itemProvider.decreaseCartItem(
                          productId, title, price, imageUrl);
                    },
                    icon: Icon(Icons.remove),
                  )
                ]),
              )
            ],
          ),
        ),
      ),
    );
  }
}
