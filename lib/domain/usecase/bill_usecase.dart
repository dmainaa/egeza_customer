
import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:easypark/app/constants.dart';
import 'package:easypark/app/di.dart';

import 'package:easypark/data/network/failure.dart';
import 'package:easypark/data/network/network_service.dart';
import 'package:easypark/domain/model/model.dart';
import 'package:easypark/domain/usecase/base_usecase.dart';

class BillUseCase extends BaseUseCase<BillUseCaseInputs, Bill>{

  NetworkService  get networkService => instance<NetworkService>();
  @override
  Future<Either<Failure, Bill>> execute(BillUseCaseInputs input) async {
    List<PaymentMethod> paymentMethods = [];
    final response = await networkService.makeStringGetRequest(
        {}, BASE_URL + "/customer/bills/${input.billId}", true);

    if(response.error){
      return left(Failure(200, response.errorMessage));
    }else{
      var jsonData = jsonDecode(response.data);

      var thebill = jsonData['data'];

      Bill bill = Bill.fromJson(thebill);

      var paymethods = jsonData['data']['payment_methods'] as List;

      paymethods.forEach((method) {
        paymentMethods.add(PaymentMethod.fromJson(method));
      });

      bill.setPaymentMethods(paymentMethods);
      return right(bill);
    }
  }

}




class BillUseCaseInputs{
  String billId;

  BillUseCaseInputs(this.billId);
}