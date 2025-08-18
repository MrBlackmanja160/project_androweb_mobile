import 'package:kalbemd/Theme/textstyle.dart';
import 'package:flutter/material.dart';

class MenuItemMotoris extends StatefulWidget {
  final String image;
  final String name;
  final IconData? icon;
  final Function()? onTap;

  const MenuItemMotoris({
    this.image = "",
    this.name = "",
    this.onTap,
    this.icon,
    Key? key,
  }) : super(key: key);

  @override
  _MenuItemMotorisState createState() => _MenuItemMotorisState();
}

class _MenuItemMotorisState extends State<MenuItemMotoris> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Image.asset(
              //   "assets/images/tokoku.png",
              //   height: 64,
              // ),
              Icon(
                widget.icon,
                size: 32,
                color: widget.onTap == null
                    ? Theme.of(context).disabledColor
                    : Theme.of(context).primaryColor,
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                widget.name,
                style: widget.onTap == null
                    ? textStyleBold.copyWith(
                        color: Theme.of(context).disabledColor)
                    : textStyleBold,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
