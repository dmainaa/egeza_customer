

import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:easypark/app/constants.dart';
import 'package:easypark/app/di.dart';
import 'package:easypark/data/network/failure.dart';
import 'package:easypark/data/network/network_service.dart';
import 'package:easypark/domain/model/model.dart';
import 'package:easypark/domain/usecase/base_usecase.dart';

import 'package:shared_preferences/shared_preferences.dart';

class VerifyPhone implements BaseUseCase<VerifyPhoneBaseInput, bool>{

  NetworkService  get networkService => instance<NetworkService>();

  late SharedPreferences  sharedPreferences;



  @override
  Future<Either<Failure, bool>> execute(VerifyPhoneBaseInput input) async{
    // TODO: implement execute
    sharedPreferences = await SharedPreferences.getInstance();
   final response = await networkService.makeStringPostRequest({
      "phone": input.phoneNumber,
      "code": input.code
    }, REGISTER_URL , false,);


   if(response.error){
     return left(Failure(202, response.errorMessage));
   }else {
     final jsonData = jsonDecode(response.data);


     bool userExists = jsonData["data"]["exists"] ?? false;
     Map<String, dynamic> data = jsonData["data"]["user"];

     User user = User.fromJson(data);
     sharedPreferences.setString("id", user.id.toString());
     sharedPreferences.setString("profile_pic", user.profile_url);
     sharedPreferences.setString("email", user.email);
     sharedPreferences.setString("phone", user.phone);

     if(userExists){


       return right(true);
     }else{
       return right(false);
     }

   }

  }




}

class VerifyPhoneBaseInput{
  String phoneNumber;
  String code;

  VerifyPhoneBaseInput(this.phoneNumber, this.code);
}