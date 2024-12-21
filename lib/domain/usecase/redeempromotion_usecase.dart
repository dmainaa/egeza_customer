import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:easypark/app/constants.dart';
import 'package:easypark/app/di.dart';
import 'package:easypark/data/network/failure.dart';
import 'package:easypark/data/network/network_service.dart';
import 'package:easypark/domain/usecase/base_usecase.dart';
import 'package:easypark/domain/usecase/redeempromotion_usecase.dart';

class RedeemPromotionUsecase extends BaseUseCase<RedeemPromotionUseCaseInput, bool>{
  NetworkService  get networkService => instance<NetworkService>();


  @override
  Future<Either<Failure, bool>> execute(RedeemPromotionUseCaseInput input) async{

    final response = await networkService.makeStringPostRequest(
        {
          "code": input.code
        }, BASE_URL+ "/customer/promotions", true);

    if(response.error){
      return left(Failure(200, response.errorMessage));
    }else{

      return right(true);
    }
  }



}








class RedeemPromotionUseCaseInput{

  final String code;

  RedeemPromotionUseCaseInput(this.code);
}