import 'package:easypark/presentation/resources/color_manager.dart';
import 'package:easypark/presentation/resources/routes_manager.dart';
import 'package:easypark/presentation/resources/theme_manager.dart';
import 'package:easypark/presentation/splash/splashscreen_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: RouteGenerator.getRoute,
      initialRoute: Routes.splashRoute,
      theme: getApplicationTheme(),

    );
  }
}


