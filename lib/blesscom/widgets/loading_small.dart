import 'package:flutter/material.dart';

class LoadingSmall extends StatelessWidget {
  const LoadingSmall({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 20,
      height: 20,
      child: CircularProgressIndicator(),
    );
  }
}
