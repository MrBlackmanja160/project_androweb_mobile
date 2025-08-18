import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    final imageSize = MediaQuery.of(context).size.width * 0.5;

    return Scaffold(
      body: Center(
        child: Image.asset(
          "assets/images/logo.png",
          fit: BoxFit.contain,
          height: imageSize,
          width: imageSize,
          alignment: Alignment.center,
        ),
      ),
    );
  }
}
