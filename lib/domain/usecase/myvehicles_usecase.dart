import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:easypark/app/constants.dart';
import 'package:easypark/app/di.dart';
import 'package:easypark/data/network/failure.dart';
import 'package:easypark/data/network/network_service.dart';
import 'package:easypark/domain/model/model.dart';
import 'package:easypark/domain/usecase/base_usecase.dart';

class MyVehiclesUseCase extends BaseUseCase<Null, List<Vehicle>>{

  NetworkService  get networkService => instance<NetworkService>();
  @override
  Future<Either<Failure, List<Vehicle>>> execute(Null input)async {
    // TODO: implement execute
    List<Vehicle> myVehicles = [];
    final response = await networkService.makeStringGetRequest(
        {}, BASE_URL + "/customer/vehicles", true);

    if(response.error){
      return left(Failure(200, response.errorMessage));
    }else{
      var jsonData = jsonDecode(response.data);

      var allVehicles = jsonData['data'] as List;

      allVehicles.forEach((vehicle) {
        myVehicles.add(Vehicle.fromJson(vehicle));
      });
      return right(myVehicles);
    }
  }

}









