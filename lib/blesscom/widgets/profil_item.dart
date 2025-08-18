import 'package:kalbemd/Theme/textstyle.dart';
import 'package:flutter/material.dart';

class ProfilItem extends StatelessWidget {
  final String title;
  final String description;
  const ProfilItem({
    this.title = "",
    this.description = "",
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: textStyleMediumBold,
        ),
        Text(
          description,
        ),
        const Divider(),
      ],
    );
  }
}
