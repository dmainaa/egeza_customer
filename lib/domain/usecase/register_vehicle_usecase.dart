import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:easypark/app/constants.dart';
import 'package:easypark/app/di.dart';
import 'package:easypark/data/network/failure.dart';
import 'package:easypark/data/network/network_service.dart';
import 'package:easypark/domain/usecase/base_usecase.dart';

class RegisterVehicleUsecase implements BaseUseCase<RegisterVehicleUseCaseInputs, bool>{

  NetworkService  get networkService => instance<NetworkService>();
  @override
  Future<Either<Failure, bool>> execute(RegisterVehicleUseCaseInputs input) async{
    // TODO: implement execute

    final response = await networkService.makeStringPostRequest(
        {
          "plate": input.plateNumber
        }, BASE_URL + "/customer/vehicles", true);

    if(response.error){
      return left(Failure(200, response.errorMessage));
    }else{
      var jsonData = jsonDecode(response.data);

      var res = jsonData['data'];

      String title = res["title"] ?? "";

      if(title.isNotEmpty){
        return right(true);
      }else{
        return right(false);
      }

    }

  }


}






class RegisterVehicleUseCaseInputs{
  String plateNumber;

  RegisterVehicleUseCaseInputs(this.plateNumber);
}