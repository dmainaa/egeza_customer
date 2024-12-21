import 'package:easypark/presentation/resources/color_manager.dart';
import 'package:easypark/presentation/resources/string_manager.dart';
import 'package:easypark/presentation/resources/style_manager.dart';
import 'package:easypark/presentation/resources/value_manager.dart';
import 'package:easypark/presentation/universal%20widgets/customtext.dart';
import 'package:flutter/material.dart';

class LogOutDialog extends StatelessWidget {
  final VoidCallback yes;
  final VoidCallback no;

  const LogOutDialog(this.yes, this.no  , {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

        Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.75,
      height: size.height * 0.2,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0)

      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: size.width * AppPadding.minuteFactor, vertical: size.width * AppPadding.minuteFactor),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Are you sure you want to log out?", style: getBoldStyle(fontSize: 18.0),),
            SizedBox(height: size.height * AppPadding.tinyFactor * 2,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [


              InkWell(
                onTap: no,
                child: Container(
                  height: 35,
                  width: MediaQuery.of(context).size.width * 0.2,
                  decoration: BoxDecoration(
                      border: Border.all(color: AppColors.defaultRed),
                      borderRadius: BorderRadius.circular(16)),
                  child:  Center(
                    child: CustomText(
                        AppStrings.no, 14, FontWeight.w700, AppColors.defaultRed),
                  ),
                ),
              ),
              SizedBox(width: size.width * AppPadding.tinyFactor * 2,),
              InkWell(
                onTap: yes,
                child: Container(
                  height: 35,
                  width: MediaQuery.of(context).size.width * 0.25,
                  decoration: BoxDecoration(
                      color: AppColors.defaultRed,
                      borderRadius: BorderRadius.circular(16)),
                  child:  Center(
                    child: CustomText(
                        AppStrings.yes, 14, FontWeight.w700, AppColors.whiteColor),
                  ),
                ),
              ),
            ],
          ),

            SizedBox(height: size.height * AppPadding.tinyFactor,),

          ],
        ),
      ),
    );

  }
}
