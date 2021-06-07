import 'package:flutter/material.dart';
import 'package:shopapp/screens/orders_screen.dart';
import 'package:shopapp/screens/products_overview_screen.dart';
import 'package:shopapp/screens/user_product_screen.dart';
import 'package:shopapp/widgets/drawer_item.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
          child: Container(
        width: double.infinity,
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.symmetric(vertical: 30, horizontal: 10),
        child: Column(
          children: [
            DrawerItem(
              routeName: ProductsOverView.routeName,
              text: 'Products',
            ),
            DrawerItem(
              routeName: OrdersScreen.routeName,
              text: 'Orders',
            ),
            DrawerItem(
              routeName: UserProductScreen.routeName,
              text: 'Manage Products',
            ),
          ],
        ),
      )),
    );
  }
}
