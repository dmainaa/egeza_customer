import 'package:easypark/presentation/resources/color_manager.dart';
import 'package:easypark/presentation/universal%20widgets/customtext.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';



class TextFieldOnBoarding extends StatelessWidget {
  final String labelText;
  final Icon? icon;
  final bool obscureText;
  final TextInputAction textInputAction;
  final Function(String)? onChanged;
  final TextInputType keyboardType;
  final Function(String)? onFieldSubmitted;
  final FormFieldValidator<String>? validator;
  final String hintText, errorText;
  final TextEditingController controller;
  final Widget? leadingIcon;
  final bool backGroundIsWhite;
  final Widget? trailingIcon;
  final bool needBigger;
  const TextFieldOnBoarding(
      this.labelText,
      this.icon,
      this.obscureText,
      this.textInputAction,
      this.keyboardType,
      this.onFieldSubmitted,
      this.validator,
      this.hintText,
      this.errorText,
      this.controller,
      this.leadingIcon,
      {required this.onChanged,
        this.backGroundIsWhite = false,
        this.trailingIcon,
        this.needBigger = false,
        Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          SizedBox(
            height: needBigger ? 140 : 60,
            width: MediaQuery.of(context).size.width,
          ),
          Positioned(
            top: 6,
            left: 0,
            right: 0,
            child: Container(
              height: needBigger ? 120 : 52,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: AppColors.blackColor,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 10, top: 3.5),
                child: TextFormField(

                  controller: controller,
                  validator: validator,
                  onFieldSubmitted: onFieldSubmitted,
                  textInputAction: textInputAction,
                  obscureText: obscureText,
                  onChanged: onChanged,


                  style: GoogleFonts.manrope(),
                  cursorHeight: 0,
                  cursorWidth: 0,
                  decoration: InputDecoration(
                    suffix: trailingIcon,
                    prefix: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: leadingIcon,
                    ),
                    hintText: hintText,
                    errorText: errorText,
                    hintStyle: const TextStyle(color: AppColors.blackColor), border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 16,
            child: Container(
              alignment: Alignment.center,
              color: backGroundIsWhite ? Colors.white : AppColors.appBarColor,
              child: Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: CustomText(labelText, 12, FontWeight.w700, Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
