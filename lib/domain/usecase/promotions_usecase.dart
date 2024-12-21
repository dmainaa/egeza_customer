



import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:easypark/app/constants.dart';
import 'package:easypark/app/di.dart';
import 'package:easypark/data/network/failure.dart';
import 'package:easypark/data/network/network_service.dart';
import 'package:easypark/domain/model/model.dart';
import 'package:easypark/domain/usecase/base_usecase.dart';

class PromotionsUseCase extends BaseUseCase<String, List<Promotion>>{

  NetworkService  get networkService => instance<NetworkService>();
  @override
  Future<Either<Failure, List<Promotion>>> execute(String input) async{
    // TODO: implement execute

    List<Promotion> allPromotions = [];
    final response = await networkService.makeStringGetRequest(
        {}, BASE_URL + "/customer/promotions", true);

    if(response.error){
      return left(Failure(200, response.errorMessage));
    }else{
      var jsonData = jsonDecode(response.data);

      var promotions = jsonData['data'] as List;

      promotions.forEach((promotion) {
        allPromotions.add(Promotion.fromJson(promotion));
      });
      return right(allPromotions);
    }
  }

}