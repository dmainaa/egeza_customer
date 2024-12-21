import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:easypark/app/constants.dart';
import 'package:easypark/app/di.dart';
import 'package:easypark/data/network/failure.dart';
import 'package:easypark/data/network/network_service.dart';
import 'package:easypark/domain/usecase/base_usecase.dart';

class CheckOutUseCase extends BaseUseCase<CheckOutUseCaseInputs, String>{

  NetworkService  get networkService => instance<NetworkService>();

  @override
  Future<Either<Failure, String>> execute(CheckOutUseCaseInputs input) async{
    final response = await networkService.makeStringPostRequest(
        {}, BASE_URL + "/customer/parkings/sessions/${input.session_id}/checkout", true);

    print(response.data);

    if(response.error){
      return left(Failure(200, response.errorMessage));
    }else{
      var jsonData = jsonDecode(response.data);

      String billId = jsonData['data']['bill']['id'].toString();


      return right(billId);
    }
  }


}

class CheckOutUseCaseInputs {
  String session_id;

  CheckOutUseCaseInputs(this.session_id);
}