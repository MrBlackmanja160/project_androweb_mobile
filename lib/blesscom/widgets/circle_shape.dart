import 'package:flutter/material.dart';

class CircleShape extends StatelessWidget {
  final double size;
  const CircleShape({this.size = 64, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        shape: BoxShape.circle,
      ),
    );
  }
}
