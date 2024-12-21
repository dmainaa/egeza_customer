import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:easypark/app/constants.dart';
import 'package:easypark/app/di.dart';
import 'package:easypark/data/network/failure.dart';
import 'package:easypark/data/network/network_service.dart';
import 'package:easypark/domain/model/model.dart';
import 'package:easypark/domain/usecase/base_usecase.dart';
import 'package:easypark/domain/usecase/parkinghistory_usecase.dart';
class ParkingHistoryUseCase extends BaseUseCase<ParkingHistoryUseCaseInput, List<ParkingHistory>>{

  NetworkService  get networkService => instance<NetworkService>();
  @override
  Future<Either<Failure, List<ParkingHistory>>> execute(ParkingHistoryUseCaseInput input) async{
    List<ParkingHistory> parkingHistory = [];
    String url = "";
    if(input.isAll){
      url = "/customer/parkings/history";
    }else{
      url = "/customer/vehicles/${input.vehicleId}";
    }
    final response = await networkService.makeStringGetRequest(
        {}, BASE_URL + url, true);

    if(response.error){

      return left(Failure(200, response.errorMessage));

    }else{
      var jsonData = jsonDecode(response.data);

      var allEntries  = input.isAll ? jsonData['data'] as List : jsonData['data']['history'] as List;

      allEntries.forEach((history) {
        parkingHistory.add(ParkingHistory.fromJson(history));
      });
      return right(parkingHistory);
    }
  }

}



class ParkingHistoryUseCaseInput{
  String vehicleId;
  bool isAll;


  ParkingHistoryUseCaseInput(this.vehicleId, this.isAll);

}