import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:easypark/app/constants.dart';
import 'package:easypark/app/di.dart';

import 'package:easypark/data/network/failure.dart';
import 'package:easypark/data/network/network_service.dart';
import 'package:easypark/domain/model/model.dart';
import 'package:easypark/domain/usecase/base_usecase.dart';
import 'package:easypark/domain/usecase/finish_up.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FinishUpUseCase extends BaseUseCase<FinishUpUseCaseInputs, bool>{
  NetworkService  get networkService => instance<NetworkService>();

 late SharedPreferences  sharedPreferences;

  @override
  Future<Either<Failure, bool>> execute(FinishUpUseCaseInputs input) async {
    sharedPreferences = await SharedPreferences.getInstance();
    String phone = await sharedPreferences.getString("phone") ?? "";
    // TODO: implement execute
    final response = await networkService.makeStringPostRequest({
      "first_name": input.first_name,
      "last_name": input.last_name,
      "phone": phone,
      "email": input.email,
      "avatar": input.image64
    }, PROFILE_URL , true,);


    if(response.error){
      return left(Failure(202, response.errorMessage));
    }else {
      final jsonData = jsonDecode(response.data);


      Map<String, dynamic> data = jsonData["data"]["user"];
      User user = User.fromJson(data);
      sharedPreferences.setString("id", user.id.toString());
      sharedPreferences.setString("profile_pic", user.profile_url);
      sharedPreferences.setString("email", user.email);
      sharedPreferences.setString("name", user.name);
      sharedPreferences.setString("phone", user.phone);


      return right(true);

    }
  }




}

class FinishUpUseCaseInputs {
  String first_name, last_name,  email, image64;


  FinishUpUseCaseInputs(this.first_name, this.last_name,  this.email, this.image64);


}