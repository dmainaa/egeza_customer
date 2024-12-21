import 'dart:convert';
import 'dart:io';


import 'package:easypark/app/di.dart';
import 'package:easypark/data/network/network_service.dart';
import 'package:easypark/presentation/resources/color_manager.dart';
import 'package:easypark/presentation/resources/style_manager.dart';
import 'package:flutter/material.dart';


import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

import '../presentation/resources/assets_manager.dart';
import '../presentation/resources/font_manager.dart';
import '../presentation/resources/string_manager.dart';
import '../presentation/resources/value_manager.dart';

class AppUtils{
  NetworkService  get networkService => instance<NetworkService>();

  Future<bool> checkInternetConnectivity() async{
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {

        return true;
      }else{
        return false;
      }
    } on SocketException catch (_) {


      return false;
    }
  }

  Future<bool> dontGoBack()async{
    return false;
  }


  NavigateToPage(BuildContext context, Widget destination){
    Navigator.of(context).push(new MaterialPageRoute(builder: (context){
      return destination;
    }));
  }

  void launchURL(String url) async {

    if (!await launch(url)) throw 'Could not launch $url';
  }
  bool validateEmail(String value) {
    if(value.isNotEmpty){
      Pattern pattern =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regex = new RegExp(pattern.toString());
      return (!regex.hasMatch(value)) ? false: true;
    }else{
      return false;
    }

  }

  Widget getLoadingContainer(){
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2)
      ),
      child: Center(
          child: _getAnimatedImage(JsonAssets.loading)
      ),
    );
  }

  Widget getPopUpDialog({required bool isSuccess, required String errorMessage, required VoidCallback onTryAgain, required BuildContext context,  String buttonText = AppStrings.dismiss }){
    Size size = MediaQuery.of(context).size;
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSize.s14),

      ),
      elevation: AppSize.s1_5,

      child: Container(
        width: double.infinity,
        height: size.height * 0.3,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: AppSize.s12, offset: Offset(AppSize.s0, AppSize.s12))],),
        child: Column(
          children: [
            _getAnimatedImage(isSuccess ? JsonAssets.success: JsonAssets.error),
            _getMessage(errorMessage),
          ],
        ),
      ),

    );
  }

  Widget _getAnimatedImage(String animationName){
    return SizedBox(
      height: 150,
      width: 150,
      child: Lottie.asset(animationName),
    );
  }

  dismissDialog(BuildContext context){
    if(_isThereCurrentDialogShowing(context)){
      Navigator.of(context, rootNavigator: true).pop(true);
    }
  }
  _isThereCurrentDialogShowing(BuildContext context)=> ModalRoute.of(context)?.isCurrent != true;

  Widget _getRetryButton(String buttonTitle, VoidCallback onPressed){
    return  Center(
      child: Padding(
        padding: EdgeInsets.all(AppPadding.p18),
        child: SizedBox(
          width: AppSize.s180 ,
          child: ElevatedButton(
              onPressed: onPressed

              , child: Text(buttonTitle, style: TextStyle(color: Colors.white),)),
        ),
      ),
    );
  }

  Widget _getMessage(String message){
    return Center(child: Text(message, style: getMediumStyle(color: AppColors.blackShade, fontSize: FontSize.s16)));

  }

  Future<LocationData> getLocation()async{
    Location location = Location();
    return await location.getLocation();
  }

  String getCurrencyString(double number){
    final formatCurrency = NumberFormat.simpleCurrency(name: 'Ksh ', decimalDigits: 2);
    String formatted_string = formatCurrency.format(number);
    return formatted_string;
  }

  showSnackbar(BuildContext  context, String message, {Color textColor = Colors.white, bool isError = false, bool showAnimation = true}){

    print(isError);
    Size size = MediaQuery.of(context).size;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: AppColors.greyColor,

      content: SizedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            showAnimation ? _getAnimatedImage(!isError ? JsonAssets.error: JsonAssets.success) : Container(),
            Center(child: Text(message, style: getMediumStyle(color: AppColors.blackColor, fontSize: FontSize.s18)))
          ],
        ),
      ), duration: const Duration(seconds: 4),));
  }

  void route(BuildContext context, Widget child) {
    Navigator.of(context).push(PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
          ) =>
      child,
      transitionsBuilder: (
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
          Widget child,
          ) =>
          SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
    ));
  }


}