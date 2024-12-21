import 'package:easypark/presentation/resources/color_manager.dart';
import 'package:easypark/presentation/universal%20widgets/customtext.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class TextFieldLocal extends StatelessWidget {
  final String labelText;
  final Icon icon;
  final bool obscureText;
  final TextInputAction textInputAction;
  final Function(String)? onChanged;
  final TextInputType keyboardType;
  final Function(String)? onFieldSubmitted;
  final FormFieldValidator<String>? validator;
  final String hintText;
  final String errorText;
  final String? initialValue;
  const TextFieldLocal(
      this.labelText,
      this.icon,
      this.obscureText,
      this.textInputAction,
      this.keyboardType,
      this.onFieldSubmitted,
      this.validator,
      this.hintText,
      this.errorText,
      {required this.onChanged,
        this.initialValue,
        Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          SizedBox(
            height: 60,
            width: MediaQuery.of(context).size.width,
          ),
          Positioned(
            top: 6,
            left: 0,
            right: 0,
            child: Container(
              height: 52,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: AppColors.blackColor,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 16, top: 3.5),
                child: TextFormField(
                  initialValue: initialValue,
                  validator: validator,
                  onFieldSubmitted: onFieldSubmitted,
                  textInputAction: textInputAction,
                  obscureText: obscureText,

                  onChanged: onChanged,
                  style: GoogleFonts.manrope(),
                  cursorColor: const Color.fromRGBO(241, 157, 57, 1),
                  decoration: InputDecoration(
                      hintText: hintText,
                      errorText: errorText,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      suffixIcon: Padding(
                        padding: const EdgeInsets.all(0),
                        child: IconTheme(
                          data: const IconThemeData(
                              color: Color.fromRGBO(241, 175, 57, 1)),
                          child: icon,
                        ),
                      )),
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
