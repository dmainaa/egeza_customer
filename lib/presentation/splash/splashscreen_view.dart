import 'dart:async';

import 'package:easypark/app/app_utils.dart';
import 'package:easypark/app/di.dart';
import 'package:easypark/presentation/home/home_page_view.dart';
import 'package:easypark/presentation/phone/pnregistration_view.dart';

import 'package:easypark/presentation/resources/color_manager.dart';
import 'package:easypark/presentation/resources/string_manager.dart';
import 'package:easypark/presentation/universal%20widgets/customtext.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SplashScreenCustom extends StatefulWidget {
  const SplashScreenCustom({Key? key}) : super(key: key);

  @override
  State<SplashScreenCustom> createState() => _SplashScreenCustomState();
}

class _SplashScreenCustomState extends State<SplashScreenCustom>
    with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;
  late SharedPreferences sharedPreferences ;
  AppUtils get appUtils => instance<AppUtils>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchLocation();
    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    animation = Tween<double>(begin: 0, end: 100).animate(controller);

    animation.addListener(
          () {
        setState(() {});
      },
    );

    controller.forward();

    Timer(
      const Duration(seconds: 3),
          () {
        Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (context){
          return checkIsLoggedin() ? HomePageView() : PNRegistration();
        }));

      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    // TODO: implement dispose

  }

  bool checkIsLoggedin(){
    bool isLoggedIn =  sharedPreferences.getBool("isLoggedin") ?? false;
    return isLoggedIn;
  }


  void fetchLocation() async{

    sharedPreferences = await SharedPreferences.getInstance();
    LocationData locationData = await appUtils.getLocation();
    print("Latitude: "+locationData.latitude.toString());
    double latitude = locationData.latitude ?? -1.3000633707844875;
    double longitude = locationData.longitude ?? 36.76768320847452;
    print("Latitude ${latitude.toString()} Longitude: ${longitude.toString()}");
    sharedPreferences.setDouble("latitude", latitude);
    print("Location from shared preferences: ${sharedPreferences.getDouble("latitude").toString()}");
    print("Location from shared preferences: ${sharedPreferences.getDouble("longitude").toString()}");
    sharedPreferences.setDouble("longitude", longitude);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          alignment: Alignment.center,
          children: [
            const SizedBox(
              width: double.infinity,
              height: double.infinity,
            ),
            TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: 259),
              duration: const Duration(milliseconds: 900),
              builder: (context, double value, child) {
                return Positioned(bottom: value, child: child as Widget);
              },
              child: Hero(
                tag: "company-logo",
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 95, vertical: 80),
                  height: 294,
                  width: 294,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: AppColors.lightRed,
                  ),
                  child: SizedBox(
                      height: 136,
                      width: 104,
                      child: SvgPicture.asset(
                        "assets/images/union.svg",
                        fit: BoxFit.cover,
                      )),
                ),
              ),
            ),
            // const Expanded(
            //   child: const SizedBox(
            //     width: double.infinity,
            //   ),
            // ),
            TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: 40),
              duration: const Duration(milliseconds: 900),
              builder: (BuildContext context, double value, child) {
                return Positioned(bottom: value, child: child as Widget);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   CustomText(
                     AppStrings.productOf, 12, FontWeight.w500, AppColors.blackColor),
                  const SizedBox(
                    width: 5,
                  ),
                  GestureDetector(
                    onTap: (){
                      appUtils.launchURL(AppStrings.alienSoftUrl);
                    },
                    child: CustomText(
                        AppStrings.alienSoft, 12, FontWeight.w500, Colors.indigo),
                  ),

                ],
              ),
            ),
            // const SizedBox(
            //   height: 43,
            // )
          ],
        ));
  }
}
