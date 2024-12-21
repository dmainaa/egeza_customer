import 'package:easypark/presentation/resources/color_manager.dart';
import 'package:easypark/presentation/resources/font_manager.dart';
import 'package:easypark/presentation/resources/style_manager.dart';
import 'package:easypark/presentation/resources/value_manager.dart';
import 'package:flutter/material.dart';



ThemeData getApplicationTheme(){
  return ThemeData(
      primaryColor: AppColors.primary,
      splashColor: AppColors.primary,
      cardTheme: CardTheme(
          color: AppColors.white,
          shadowColor: AppColors.lightgrey,
          elevation: AppSize.s4
      ),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        color: AppColors.primary,
        elevation: AppSize.s4,
        shadowColor: AppColors.primaryOpacity70,


      ),
      buttonTheme:  ButtonThemeData(
          shape: StadiumBorder(),
          disabledColor: AppColors.textGrey,
          buttonColor: AppColors.primary,
          splashColor: AppColors.primaryOpacity70
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              textStyle: getRegularStyle(color: AppColors.white, ),
              backgroundColor: AppColors.primary,
              shape:  RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSize.s12)
              )
          )
      ),

      inputDecorationTheme: InputDecorationTheme(
        contentPadding: EdgeInsets.all(8.0),
        hintStyle: getRegularStyle(color: AppColors.blackShade),
        labelStyle: getMediumStyle(color: AppColors.blackShade),
        errorStyle: getRegularStyle(color: Colors.red),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.blackShade, width: AppSize.s1_5),
            borderRadius: BorderRadius.all(Radius.circular(AppSize.s8))
        ),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppColors.blackShade,
              width: AppSize.s1_5,

            ),
            borderRadius: BorderRadius.all(Radius.circular(AppSize.s8))

        ),
        errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppColors.primary,
              width: AppSize.s1_5,

            ),
            borderRadius: BorderRadius.all(Radius.circular(AppSize.s8))

        ),
        focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppColors.primary,
              width: AppSize.s1_5,

            ),
            borderRadius: BorderRadius.all(Radius.circular(AppSize.s8))

        ),
      )
  );
}