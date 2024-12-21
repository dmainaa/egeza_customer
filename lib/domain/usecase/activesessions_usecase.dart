import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:easypark/app/constants.dart';
import 'package:easypark/app/di.dart';
import 'package:easypark/data/network/failure.dart';
import 'package:easypark/data/network/network_service.dart';
import 'package:easypark/domain/model/model.dart';
import 'package:easypark/domain/usecase/base_usecase.dart';

class ActiveSessionsUsecase extends BaseUseCase<String, List<Session>>{
  NetworkService  get networkService => instance<NetworkService>();
  @override
  Future<Either<Failure, List<Session>>> execute(String input)async {
    // TODO: implement execute
    List<Session> activeSessions = [];
    final response = await networkService.makeStringGetRequest(
        {}, BASE_URL + "/customer/parkings/sessions", true);

    if(response.error){
      return left(Failure(200, response.errorMessage));
    }else{
      var jsonData = jsonDecode(response.data);

      var allSessions = jsonData['data'] as List;

      allSessions.forEach((session) {
        activeSessions.add(Session.fromJson(session));
      });
      return right(activeSessions);
    }
  }

}