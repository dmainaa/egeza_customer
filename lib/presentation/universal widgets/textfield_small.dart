import 'package:easypark/presentation/resources/color_manager.dart';
import 'package:easypark/presentation/universal%20widgets/customtext.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class TextFieldOnboardingSmall extends StatelessWidget {
  final String labelText;
  final Icon? icon;
  final bool obscureText;
  final TextInputAction textInputAction;
  final Function(String)? onChanged;
  final TextInputType keyboardType;
  final Function(String)? onFieldSubmitted;
  final FormFieldValidator<String>? validator;
  final String hintText;
  final TextEditingController? controller;
  final String? initialValue;
  final Widget? trailingIcon;
  const TextFieldOnboardingSmall(
      this.labelText,
      this.icon,
      this.obscureText,
      this.textInputAction,
      this.keyboardType,
      this.onFieldSubmitted,
      this.validator,
      this.hintText,

      {required this.onChanged,
        this.initialValue,
        this.controller,
        this.trailingIcon,
        Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          SizedBox(
            height: 60,
            width: MediaQuery.of(context).size.width * 0.42,
          ),
          Positioned(
            top: 6,
            left: 0,
            right: 0,
            child: Container(
              height: 52,
              width: MediaQuery.of(context).size.width * 0.42,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: AppColors.blackColor,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 10, top: 3.5),
                child: TextFormField(
                  initialValue: initialValue,
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
                    hintText: hintText,

                    hintStyle: const TextStyle(color: AppColors.blackColor),
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
            left: 14,
            child: Container(
              alignment: Alignment.center,
              color: AppColors.lightRed,
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
