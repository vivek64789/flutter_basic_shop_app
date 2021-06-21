import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/auth.dart';
import 'package:shopapp/providers/cart.dart';
import 'package:shopapp/providers/orders.dart';
import 'package:shopapp/providers/products.dart';
import 'package:shopapp/screens/auth_screen.dart';
import 'package:shopapp/screens/cart_screen.dart';
import 'package:shopapp/screens/edit_product_screen.dart';
import 'package:shopapp/screens/orders_screen.dart';
import 'package:shopapp/screens/product_detail_screen.dart';
import 'package:shopapp/screens/products_overview_screen.dart';
import 'package:shopapp/screens/user_product_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => Auth(),
          ),
          ChangeNotifierProxyProvider<Auth, Products>(
            create: (_) => Products("", []),
            update: (ctx, auth, previousProducts) =>
                Products(auth.token, previousProducts!.items),
          ),

          // here it is the highest point from where this data will
          // be changed and its all
          //child will be able to access the data and it will not
          // rebuid all instead only  who listen for this

          ChangeNotifierProvider(
            create: (context) => Cart(),
          ),
          ChangeNotifierProxyProvider<Auth, Orders>(
            create: (_) => Orders("", []),
            update: (_, auth, previousOrder) =>
                Orders(auth.token, previousOrder!.orders),
          ),
        ],
        child: Consumer<Auth>(builder: (ctx, auth, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            routes: {
              ProductDetailScreen.routeName: (context) => ProductDetailScreen(),
              CartScreen.routeName: (context) => CartScreen(),
              OrdersScreen.routeName: (context) => OrdersScreen(),
              ProductsOverView.routeName: (context) => ProductsOverView(),
              UserProductScreen.routeName: (context) => UserProductScreen(),
              EditProductScreen.routeName: (context) => EditProductScreen(),
            },
            title: 'Shop App',
            theme: ThemeData(
              primarySwatch: Colors.purple,
              accentColor: Colors.deepOrange,
              fontFamily: 'Poppins',
            ),
            home: auth.isAuthenticated ? ProductsOverView() : AuthScreen(),
          );
        }));
  }
}
