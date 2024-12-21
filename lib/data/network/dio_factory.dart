import 'package:dio/dio.dart';
import 'package:easypark/app/constants.dart';
import 'package:flutter/foundation.dart';

import 'package:shared_preferences/shared_preferences.dart';

const String APPLICATION_JSON = "application/json";
const String CONTENT_TYPE = "content-type";
const String ACCEPT = "accept";
const String AUTHORIZATION = "authorization";
const String DEFAULT_LANGUAGE = "language";

class DioFactory{
  SharedPreferences _appPreferences;


  DioFactory(this._appPreferences);

  Future<Dio> getDio() async{

    Dio dio = Dio();
    int _timeOut = 60 * 1000;



    Map<String, String> headers = {
      CONTENT_TYPE: APPLICATION_JSON,
      ACCEPT: APPLICATION_JSON,
      AUTHORIZATION: "token from API",

    };

    dio.options = BaseOptions(
      baseUrl: BASE_URL,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: headers
    );




    return dio;

  }


}