import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shopapp/providers/orders.dart' as ord;

class OrderItem extends StatefulWidget {
  final ord.OrderItem orders;
  const OrderItem({
    Key? key,
    required this.orders,
  }) : super(key: key);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool _expanded = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text("Rs. ${widget.orders.amount}"),
            trailing: IconButton(
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  print(_expanded);
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          Divider(),
          if (_expanded)
            Container(
              padding: EdgeInsets.all(10),
              height: min(
                widget.orders.products.length * 40.0,
                100,
              ),
              child: ListView.builder(
                itemCount: widget.orders.products.length,
                itemBuilder: (item, index) {
                  return Card(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${widget.orders.products[index].title}",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "${widget.orders.products[index].quantity} x Rs. ${widget.orders.amount}",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            )
        ],
      ),
    );
  }
}
