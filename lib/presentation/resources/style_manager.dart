import 'package:easypark/presentation/resources/font_manager.dart';
import 'package:flutter/material.dart';




TextStyle _getTextStyle(double fontSize,  String fontFamily,  Color? color, FontWeight fontWeight){

  return TextStyle(fontSize: fontSize, fontFamily: fontFamily, color: color, fontWeight: fontWeight);

}

TextStyle getRegularStyle({double fontSize = FontSize.s12,  Color? color}){

  return _getTextStyle(fontSize, FontConstants.fontFamily, color!, FontWeightManager.regular);

}

TextStyle getLightStyle({double fontSize = FontSize.s12,   Color? color}){

  return _getTextStyle(fontSize, FontConstants.fontFamily, color, FontWeightManager.light);

}

TextStyle getBoldStyle({double fontSize = FontSize.s12,   Color? color}){

  return _getTextStyle(fontSize, FontConstants.fontFamily, color, FontWeightManager.Bold);

}

TextStyle getSemiBoldStyle({double fontSize = FontSize.s12,   Color? color}){

  return _getTextStyle(fontSize, FontConstants.fontFamily, color, FontWeightManager.semiBold);

}


TextStyle getMediumStyle({double fontSize = FontSize.s12,   Color? color}){

  return _getTextStyle(fontSize, FontConstants.fontFamily, color, FontWeightManager.medium);

}