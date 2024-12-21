import 'package:easypark/presentation/resources/color_manager.dart';
import 'package:easypark/presentation/universal%20widgets/customtext.dart';
import 'package:flutter/material.dart';


class LargeButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback? onPressed;
  final Widget? iconOnLeft;
  final Widget? iconOnRight;
  final Color? backgroundColor;
  const LargeButton(this.buttonText, this.iconOnLeft, this.iconOnRight,
      {this.onPressed, this.backgroundColor, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        alignment: Alignment.center,
        height: 56,
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: backgroundColor),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              iconOnLeft as Widget,
              const SizedBox(
                width: 15,
              ),
              CustomText(buttonText, 14, FontWeight.w700, AppColors.whiteColor),
              const SizedBox(
                width: 15,
              ),
              iconOnRight as Widget
            ]),
      ),
    );
  }
}
