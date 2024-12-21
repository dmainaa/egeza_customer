

import 'dart:convert';
import 'dart:ffi';

import 'package:dartz/dartz.dart';
import 'package:easypark/app/constants.dart';
import 'package:easypark/app/di.dart';
import 'package:easypark/data/network/failure.dart';
import 'package:easypark/data/network/network_service.dart';
import 'package:easypark/domain/model/model.dart';
import 'package:easypark/domain/usecase/base_usecase.dart';

class MyAccountUseCase extends BaseUseCase<String, MyAccount>{

  NetworkService  get networkService => instance<NetworkService>();
  @override
  Future<Either<Failure, MyAccount>> execute(String input) async{
    // TODO: implement execute

    final response = await networkService.makeStringGetRequest(
        {}, BASE_URL + "/customer/account", true);

    if(response.error){

      return left(Failure(200, response.errorMessage));

    }else{

      var jsonData = jsonDecode(response.data);

      var accountData = jsonData['data'];

      MyAccount myAccount = MyAccount.fromJson(accountData);

      return right(myAccount);
    }
  }

}

