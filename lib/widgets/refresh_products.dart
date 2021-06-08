import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import '../providers/products.dart';

class RefreshProducts extends StatelessWidget {
  final Widget child;
  final BuildContext context;
  const RefreshProducts({Key? key, required this.child, required this.context}) : super(key: key);

  Future<void> _refreshProducts() async {
    await Provider.of<Products>(context, listen: false).fetchAndSetProducts();
 
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(child: child, onRefresh: _refreshProducts);
  }
}
