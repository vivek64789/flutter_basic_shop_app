import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/orders.dart' show Orders;
import 'package:shopapp/widgets/drawer.dart';
import 'package:shopapp/widgets/order_item.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  var _ordersFuture;

  Future _obtainOrderFuture() {
    return Provider.of<Orders>(context, listen: false).getSetOrders();
  }

  @override
  void initState() {
    _ordersFuture = _obtainOrderFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerWidget(),
      appBar: AppBar(
        title: Text("All Orders"),
      ),
      body: FutureBuilder(
          future: _ordersFuture,
          builder: (ctx, dataSnapShot) {
            if (dataSnapShot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator.adaptive(),
              );
            } else {
              if (dataSnapShot.error != null) {
                Center(
                  child: Text("Error occured"),
                );
              } else {
                return Consumer<Orders>(builder: (ctx, ordersProvider, child) {
                  return ListView.builder(
                      itemCount: ordersProvider.orders.length,
                      itemBuilder: (context, index) {
                        return OrderItem(orders: ordersProvider.orders[index]);
                      });
                });
              }
            }
            return Text("");
          }),
    );
  }
}
