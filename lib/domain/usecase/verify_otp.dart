import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:easypark/app/constants.dart';
import 'package:easypark/app/di.dart';
import 'package:easypark/data/network/failure.dart';
import 'package:easypark/data/network/network_service.dart';
import 'package:easypark/domain/model/model.dart';
import 'package:easypark/domain/usecase/base_usecase.dart';
import 'package:easypark/domain/usecase/verify_otp.dart';
import 'package:easypark/domain/usecase/verify_phone.dart';
import 'package:easypark/presentation/otp/otp_viewmodel.dart';

import 'package:shared_preferences/shared_preferences.dart';

class VerifyOTPUseCase extends BaseUseCase<VerifyOTPUsecaseInput, bool>{



  NetworkService  get networkService => instance<NetworkService>();

  late SharedPreferences  sharedPreferences;
  @override
  Future<Either<Failure, bool>> execute(VerifyOTPUsecaseInput input) async{
    sharedPreferences = await SharedPreferences.getInstance();
    String id = await sharedPreferences.getString("id") ?? "";

    final response = await networkService.makeStringPostRequest({
      "otp": input.enteredOtp

    }, BASE_URL + "/customer/$id/verify" , false,);


    if(response.error){
      return left(Failure(202, response.errorMessage));
    }else {

      final jsonData = jsonDecode(response.data);
      Map<String, dynamic> data = jsonData["data"]["user"];
      String token = jsonData["data"]["token"];

      print("Saved token $token");
      User user = User.fromJson(data);
      sharedPreferences.setString("id", user.id.toString());
      sharedPreferences.setString("profile_pic", user.profile_url);
      sharedPreferences.setString("email", user.email);
      sharedPreferences.setString("name", user.name);
      sharedPreferences.setString("phone", user.phone);
      sharedPreferences.setString("token", token);

      if(user.name.isEmpty){
        return right(false);
      }else{
        return right(true);
      }


    }
  }



}


class VerifyOTPUsecaseInput{
  String enteredOtp;

  VerifyOTPUsecaseInput(this.enteredOtp);
}