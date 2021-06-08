import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/products.dart';
import 'package:shopapp/screens/edit_product_screen.dart';
import 'package:shopapp/widgets/drawer.dart';
import 'package:shopapp/widgets/manage_user_product_item.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = "/manage_user-product";
  const UserProductScreen({Key? key}) : super(key: key);


  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchAndSetProducts();
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<Products>(context);
    return Scaffold(
      drawer: DrawerWidget(),
      appBar: AppBar(
        title: const Text("Manage Product"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(EditProductScreen.routeName, arguments: '');
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _refreshProducts(context),
        child: Padding(
          padding: EdgeInsets.all(
            20,
          ),
          child: ListView.builder(
            itemBuilder: (_, index) {

              return ManageUserProductItem(
                id: productProvider.items[index].id,
                title: productProvider.items[index].title,
                imageUrl: productProvider.items[index].imageUrl,
                productId: productProvider.items[index].id,
              );
            },
            itemCount: productProvider.items.length,
          ),
        ),
      ),
    );
  }
}
