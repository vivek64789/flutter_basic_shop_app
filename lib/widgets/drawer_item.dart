import 'package:flutter/material.dart';

class DrawerItem extends StatelessWidget {
  final String routeName;
  final String text;
  const DrawerItem({Key? key, required this.routeName, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        width: double.infinity,
        child: TextButton(
          onPressed: () {
            Navigator.of(context).pushReplacementNamed(routeName);
          },
          child: Text(
            text,
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}
