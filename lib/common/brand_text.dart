import 'package:flutter/material.dart';

class BrandTexts {
  // text common style
  static TextStyle textStyle({
    double fontSize = 16.0,
    FontWeight? fontWeight,
    Color? color,
    bool isCrossText = false,
    bool isUnderlineText = false,
    double letterSpacing = 0.2,
    double? height,
    FontStyle fontStyle = FontStyle.normal,
    String? fontFamily,
  }) =>
      TextStyle(
          fontFamily: fontFamily /* ?? brandFont */,
          fontStyle: fontStyle,
          fontSize: fontSize,
          fontWeight: fontWeight,
          letterSpacing: letterSpacing,
          color: color,
          height: height,
          decoration: isCrossText
              ? TextDecoration.lineThrough
              : isUnderlineText
                  ? TextDecoration.underline
                  : TextDecoration.none);
}
