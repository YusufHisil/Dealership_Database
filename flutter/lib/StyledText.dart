import 'package:flutter/material.dart';

class StyledText extends StatelessWidget {
  const StyledText(this.text,{super.key, this.clr = Colors.black, this.size = 16});
  final String text;
  final Color clr;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Text(text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: 'Arial',
          color: clr,
          fontSize: size,
        ));
  }
}
