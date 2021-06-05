import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Badge extends StatelessWidget {
  Widget child;
  String value;
  Color color;

  Badge({
    Key? key,
    required this.child,
    required this.value,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          child: child,
        ),
        Positioned(
            right: 3,
            top: 8,
            child: Container(
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: color,
              ),
              constraints: BoxConstraints(
                maxHeight: 16,
                minHeight: 16,
              ),
              child: Text(
                value,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 10),
              ),
            ))
      ],
    );
  }
}
