import 'package:kalbemd/Theme/textstyle.dart';
import 'package:flutter/material.dart';

class LabeledText extends StatefulWidget {
  final String title;
  final String description;

  const LabeledText({
    this.title = "",
    this.description = "",
    Key? key,
  }) : super(key: key);

  @override
  _LabeledTextState createState() => _LabeledTextState();
}

class _LabeledTextState extends State<LabeledText> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: textStyleBold,
        ),
        Text(
          widget.description,
        ),
      ],
    );
  }
}
