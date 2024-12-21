import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:easypark/app/constants.dart';
import 'package:easypark/app/di.dart';
import 'package:easypark/data/network/failure.dart';
import 'package:easypark/data/network/network_service.dart';
import 'package:easypark/domain/model/model.dart';
import 'package:easypark/domain/usecase/base_usecase.dart';
import 'package:easypark/domain/usecase/homepage_usecase.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePageUseCase extends BaseUseCase<HomePageUseCaseInputs, List<ParkingSpot>>{

  NetworkService  get networkService => instance<NetworkService>();

  late SharedPreferences  sharedPreferences;

  @override
  Future<Either<Failure, List<ParkingSpot>>> execute(HomePageUseCaseInputs input) async{
    sharedPreferences = await SharedPreferences.getInstance();
    List<ParkingSpot> parkingSpots = [];
    print("New latitude:" + input.latitude.toString() + "New longitude" +input.longitude.toString());

    final response = await networkService.makeStringGetRequest(
        {}, BASE_URL + "/customer/parkings?latitude=${input.latitude.toString()}&longitude=${input.longitude.toString()}", true);

    if(response.error){
      return left(Failure(200, response.errorMessage));
    }else{
      var jsonData = jsonDecode(response.data);

      var allParkings = jsonData['data']['parkings'] as List;

      allParkings.forEach((parkingSpot) {
        ParkingSpot spot  = ParkingSpot.fromJson(parkingSpot);
        spot.setHasAtiveSessions(jsonData['data']['has_active_sessions'] ?? false);
        spot.setQRCode(jsonData['data']['qr_code'] ?? "");
        parkingSpots.add(spot);
      });
      return right(parkingSpots);
    }


  }


}





class HomePageUseCaseInputs{
  double latitude;
  double longitude;

  HomePageUseCaseInputs(this.latitude, this.longitude);
}