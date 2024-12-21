import 'dart:convert';


import 'package:easypark/app/app_utils.dart';
import 'package:easypark/app/di.dart';
import 'package:easypark/data/network/api_response.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';


class NetworkService{

  AppUtils get appUtils => instance<AppUtils>();




  String token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE2MjkxMjIwNDIsInN1YiI6NSwidG9rZW5fdHlwZSI6ImFjY2VzcyJ9.t0GxtpU4M-LzCEYkPxHBo1k8jg4Z0xhvQP7hK5M9ugI";


  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();


  Future<String> getToken() async{
    final SharedPreferences prefs = await _prefs;
    String? token = prefs.getString('token');
    debugPrint("The token: $token");
    return token.toString();
  }

  Future<String> getAttestationString() async{
    final SharedPreferences prefs = await _prefs;
    String? token = prefs.getString('attestation') ?? "";
    return token.toString();
  }



  Future<String> getDeviceId() async{
    final SharedPreferences prefs = await _prefs;
    String? token = prefs.getString('deviceId');
    return token.toString();
  }

  var  headers = {
    'Accept': 'application/json',
    'Content-Type': 'application/json',

  };

  Future<bool> checkConnectivity() async{
    bool isconnected = await appUtils.checkInternetConnectivity();
    return isconnected;
  }
  Future<APIResponse<String>>  makeStringGetRequest(Map<String, dynamic> body, String url, bool includeToken) async{

    bool isconnected  = await appUtils.checkInternetConnectivity();
    Uri uri = Uri.parse(url);

    if(isconnected){
      String the_token = '';
      if(includeToken){
        the_token = await getToken();

      }
      String attestation = await getAttestationString();
      return http.get(uri , headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        "Authorization": 'Bearer ' + the_token


      },).timeout(Duration(seconds: 30), onTimeout: (){
        return  http.Response('Network Time Out', 500);
      }).then((data){

        final jsonData = jsonDecode(data.body);
        debugPrint(jsonData.toString());
        if(data.statusCode == 200){

          return APIResponse<String>(data.body, "", false);


        } else if(data.statusCode == 400){
          return APIResponse<String>("", "Something wrong happened", true);
        }else if(data.statusCode == 402){
          return APIResponse<String>("", "Validation Error", true);
        }
        else if(data.statusCode == 401){
          return APIResponse<String>("", "Authentication Error", true);
        } else{

          return APIResponse<String>("", "An error occurred", true);

        }
      }).catchError((error){


        return APIResponse<String>("", "An error occurred", true);
      });
    }else{
      return APIResponse<String>("", "Check your connection", true);
    }
  }


  Future<APIResponse<String>>  makeStringPostRequest(Map<String, dynamic> body, String url, bool includeToken) async{

    bool isconnected  = await appUtils.checkInternetConnectivity();
    Uri uri = Uri.parse(url);

    if(isconnected){
      String the_token = '';
      if(includeToken){
        the_token = await getToken();

      }

      String attestation = await getAttestationString();
      return http.post(uri , headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        "Authorization": 'Bearer ' + the_token


      }, body: json.encode(body)).timeout(Duration(seconds: 30), onTimeout: (){
        return  http.Response('Network Time Out', 500);
      }).then((data){

        final jsonData = jsonDecode(data.body);
        debugPrint(jsonData.toString());
        if(data.statusCode == 200 || data.statusCode == 201){

          return APIResponse<String>(data.body, "", false);


        } else if(data.statusCode == 400){
          return APIResponse<String>("", "Something wrong happened", true);
        }else if(data.statusCode == 402){
          return APIResponse<String>("", "Validation Error", true);
        }
        else if(data.statusCode == 401){
          return APIResponse<String>("", "Authentication Error", true);
        } else{

          return APIResponse<String>("", "An error occurred", true);

        }
      }).catchError((error){


        return APIResponse<String>("", "An error occurred", true);
      });
    }else{
      return APIResponse<String>("", "Check your connection", true);
    }
  }

  Future<APIResponse<String>>  makeStringDeleteRequest(Map<String, dynamic> body, String url, bool includeToken) async{

    bool isconnected  = await appUtils.checkInternetConnectivity();
    Uri uri = Uri.parse(url);

    if(isconnected){
      String the_token = '';
      if(includeToken){
        the_token = await getToken();

      }

      String attestation = await getAttestationString();
      return http.delete(uri , headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        "Authorization": 'Bearer ' + the_token


      }, body: json.encode(body)).timeout(Duration(seconds: 30), onTimeout: (){
        return  http.Response('Network Time Out', 500);
      }).then((data){

        final jsonData = jsonDecode(data.body);
        debugPrint(jsonData.toString());
        if(data.statusCode == 200){

          return APIResponse<String>(data.body, "", false);


        } else if(data.statusCode == 400){
          return APIResponse<String>("", "Something wrong happened", true);
        }else if(data.statusCode == 402){
          return APIResponse<String>("", "Validation Error", true);
        }
        else if(data.statusCode == 401){
          return APIResponse<String>("", "Authentication Error", true);
        } else{

          return APIResponse<String>("", "An error occurred", true);

        }
      }).catchError((error){


        return APIResponse<String>("", "An error occurred", true);
      });
    }else{
      return APIResponse<String>("", "Check your connection", true);
    }
  }



}