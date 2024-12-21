import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

class CustomText extends StatelessWidget {
   String textBody;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;
  final centerJustification;
   CustomText(this.textBody, this.fontSize, this.fontWeight, this.color,
      {this.centerJustification = false, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(textBody,
        textAlign: centerJustification ? TextAlign.center : TextAlign.left,
        style: GoogleFonts.manrope(
            fontSize: fontSize, fontWeight: fontWeight, color: color), maxLines: 2, overflow: TextOverflow.ellipsis,);
  }
}

class CustomTextUnerlined extends StatelessWidget {
  final String textBody;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;
  const CustomTextUnerlined(
      this.textBody, this.fontSize, this.fontWeight, this.color,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(textBody,

        style: GoogleFonts.manrope(
            decoration: TextDecoration.underline,
            fontSize: fontSize,
            fontWeight: fontWeight,
            color: color));
  }
}
