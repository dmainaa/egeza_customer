import 'package:easypark/app/app.dart';
import 'package:easypark/app/di.dart';
import 'package:flutter/material.dart';

final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await initAppModule();
  runApp(MyApp());
}


