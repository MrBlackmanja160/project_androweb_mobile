import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final Widget? child;
  const Background({Key? key, @required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    // ignore: sized_box_for_whitespace
    return Container(
      width: double.infinity,
      height: size.height,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            right: 190,
            bottom: 550,
            child:
                Image.asset("assets/background/besar.png", width: size.width),
          ),
          Positioned(
            top: 10,
            left: 230,
            child:
                Image.asset("assets/background/kecil.png", width: size.width),
          ),
          // Positioned(
          //   top: 50,
          //   right: 30,
          //   child:
          //       Image.asset("assets/images/main.png", width: size.width * 0.35),
          // ),
          // Positioned(
          //   bottom: 0,
          //   right: 0,
          //   child: Image.asset("assets/images/bottom1.png", width: size.width),
          // ),
          // Positioned(
          //   bottom: 0,
          //   right: 0,
          //   child: Image.asset("assets/images/bottom2.png", width: size.width),
          // ),
          child!
        ],
      ),
    );
  }
}
