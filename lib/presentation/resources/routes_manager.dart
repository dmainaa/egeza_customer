

import 'package:easypark/presentation/phone/pnregistration_view.dart';
import 'package:easypark/presentation/resources/string_manager.dart';
import 'package:easypark/presentation/resources/style_manager.dart';
import 'package:easypark/presentation/splash/splashscreen_view.dart';
import 'package:flutter/material.dart';


class Routes{
  static const String splashRoute = "/";
  static const String phone = "/phone";
  // static const String loginRoute = "/login";
  // static const String registerRoute = "/register";
  // static const String mainRoute = "/main";
  // static const String storeDetailsRoute = "/storeDetails";
  // static const String forgotPasswordRoute = "/forgotPassword";
}

class RouteGenerator{
  static Route<dynamic> getRoute(RouteSettings routeSettings){

    switch(routeSettings.name){
      case Routes.splashRoute:
        return MaterialPageRoute(builder: (_) => SplashScreenCustom());
        break;
      case Routes.phone:
        return MaterialPageRoute(builder: (_) => PNRegistration());
        break;
      // case Routes.onBoardingRoute:
      //   return MaterialPageRoute(builder: (_) => OnBoardingView());
      //   break;
      // case Routes.registerRoute:
      //   initRegisterModule();
      //   return MaterialPageRoute(builder: (_) => RegisterView());
      //   break;
      // case Routes.forgotPasswordRoute:
      //   return MaterialPageRoute(builder: (_) => ForgotPasswordView());
      //   break;
      // case Routes.mainRoute:
      //   return MaterialPageRoute(builder: (_) => MainView());
      //   break;
      // case Routes.storeDetailsRoute:
      //   return MaterialPageRoute(builder: (_) => StoreDetailsView());
      //   break;
      default:
        return undefinedRoute();
        break;
    }


  }

  static Route<dynamic> undefinedRoute(){
    return MaterialPageRoute(builder: (_)=>Scaffold(
      appBar: AppBar(title: Text(AppStrings.noRouteFound),),
      body: Center(
        child: Text(AppStrings.noRouteFound, style: getSemiBoldStyle(fontSize: 15.0, color: Colors.purpleAccent),),
      ),

    ));
  }
}