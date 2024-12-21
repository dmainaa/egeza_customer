import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:easypark/app/constants.dart';
import 'package:easypark/app/di.dart';
import 'package:easypark/data/network/failure.dart';
import 'package:easypark/data/network/network_service.dart';
import 'package:easypark/domain/model/model.dart';
import 'package:easypark/domain/usecase/base_usecase.dart';
import 'package:easypark/domain/usecase/makepayment_usecase.dart';

class MakePaymentUseCase extends BaseUseCase<MakePaymentUseCaseInputs, PaymentStatus>{

  NetworkService  get networkService => instance<NetworkService>();
  @override
  Future<Either<Failure, PaymentStatus>> execute(MakePaymentUseCaseInputs input) async{
    print("called");
    print(input.payment_client);
    print(input.payment_method);
    print(input.billId);
    final response = await networkService.makeStringPostRequest(
        {
          "payment_method": input.payment_method,
          "payment_client": input.payment_client,
        }, BASE_URL + "/customer/bills/${input.billId}/pay", true);

    if(response.error){
      return left(Failure(200, response.errorMessage));
    }else{
      final jsonData = jsonDecode(response.data);

      Map<String, dynamic> map = jsonData["data"];

      PaymentStatus status = PaymentStatus.fromJson(map);
      print("Payment status: ${status.status} ");
      print("Payment message: ${status.message} ");
      return right(status);
    }
  }

}





class MakePaymentUseCaseInputs{
  String billId;
  String payment_method;
  String payment_client;

  MakePaymentUseCaseInputs(
      this.billId, this.payment_method, this.payment_client);
}