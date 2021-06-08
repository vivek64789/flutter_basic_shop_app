import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/products.dart';
import 'package:shopapp/screens/edit_product_screen.dart';

class ManageUserProductItem extends StatelessWidget {
  const ManageUserProductItem(
      {Key? key,
      required this.id,
      required this.title,
      required this.imageUrl,
      required this.productId})
      : super(key: key);
  final String id;
  final String title;
  final String imageUrl;
  final String productId;

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<Products>(context, listen: false);
    var scaffoldMessenger = ScaffoldMessenger.of(context);
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(imageUrl),
        ),
        title: Text(title),
        trailing: Container(
            width: 100,
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed(EditProductScreen.routeName, arguments: id);
                  },
                  icon: Icon(
                    Icons.edit,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    try {
                      await productProvider.removeItem(productId).then((_) {
                        scaffoldMessenger.showSnackBar(SnackBar(
                            backgroundColor: Colors.green,
                            content: Text(
                              "Deleted Successfully",
                              textAlign: TextAlign.center,
                            )));
                      });
                    } catch (error) {
                      scaffoldMessenger.showSnackBar(SnackBar(
                          backgroundColor: Colors.red,
                          content: Text(
                            "$error",
                            textAlign: TextAlign.center,
                          )));
                    }
                  },
                  icon: Icon(
                    Icons.delete,
                    color: Theme.of(context).errorColor,
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
