import 'package:easypark/presentation/resources/color_manager.dart';
import 'package:easypark/presentation/resources/string_manager.dart';
import 'package:easypark/presentation/universal%20widgets/customtext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';



class AboutView extends StatefulWidget {
  const AboutView({Key? key}) : super(key: key);

  @override
  State<AboutView> createState() => _AboutViewState();
}

class _AboutViewState extends State<AboutView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: Column(
        children: [
          header(),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                companyLogo(),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  alignment: Alignment.center,
                  height: 184,
                  width: 311,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      color: const Color.fromRGBO(246, 246, 246, 1)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      listWidget("assets/images/rate_app.svg", "Rate App"),
                      listWidget(
                          "assets/images/visit_website.svg", "Visit Website"),
                      listWidget("assets/images/licenses.svg", "Licenses")
                    ],
                  ),
                ),
                 CustomText(
                    "Version 2.3.1", 14, FontWeight.w400, AppColors.blackColor),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomText(AppStrings.productOf, 12, FontWeight.w500,
                        AppColors.blackColor),
                    const SizedBox(
                      width: 10,
                    ),
                    Image.asset("assets/images/company_logo.png")
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  ListTile listWidget(String svgAsset, String text) {
    return ListTile(
      leading: SvgPicture.asset(svgAsset),
      title: CustomText(text, 16, FontWeight.w600, AppColors.blackColor),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 18,
        color: AppColors.blackColor,
      ),
    );
  }

  Container companyLogo() {
    return Container(
      height: 174,
      width: 174,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100), color: AppColors.lightRed),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 35, horizontal: 45),
        child: SvgPicture.asset(
          "assets/images/union_about.svg",
          // fit: BoxFit.cover,
        ),
      ),
    );
  }

  Container header() {
    return Container(
      height: 100,
      decoration: const BoxDecoration(
          color: Color.fromRGBO(246, 246, 246, 1),
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(32),
              bottomRight: Radius.circular(32))),
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: const Color.fromRGBO(246, 246, 246, 1),
      leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: const Icon(
            Icons.arrow_back,
            color: AppColors.blackColor,
          )),
      titleSpacing: 0,
      title:
       CustomText("About", 16, FontWeight.w700, AppColors.blackColor),
    );
  }

}
