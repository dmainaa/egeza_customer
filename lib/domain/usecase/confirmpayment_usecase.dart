import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:easypark/app/constants.dart';
import 'package:easypark/app/di.dart';
import 'package:easypark/data/network/failure.dart';
import 'package:easypark/data/network/network_service.dart';
import 'package:easypark/domain/usecase/base_usecase.dart';
import 'package:easypark/domain/usecase/confirmpayment_usecase.dart';

class ConfirmPaymentUseCase extends BaseUseCase<ConfirmPaymentUseCaseInputs, String>{

  NetworkService get networkService => instance<NetworkService>();
  @override
  Future<Either<Failure, String>> execute(ConfirmPaymentUseCaseInputs input) async{
    final response = await networkService.makeStringGetRequest(
        {
          "payment_method": input.payment_method,
          "payment_client": input.payment_client,
        }, BASE_URL  + "/customer/bills/${input.billId}/confirm-payment", true);

    if(response.error){
      return left(Failure(200, response.errorMessage));
    }else{
      final jsonData = jsonDecode(response.data);

      String status = jsonData["data"]["status"] ?? "";
      return right(status);

    }
  }
  }






class ConfirmPaymentUseCaseInputs{
  String billId;
  String payment_method;
  String payment_client;

  ConfirmPaymentUseCaseInputs(
      this.billId, this.payment_method, this.payment_client);
}