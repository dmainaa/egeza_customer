
import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:easypark/app/constants.dart';
import 'package:easypark/app/di.dart';
import 'package:easypark/data/network/failure.dart';
import 'package:easypark/data/network/network_service.dart';
import 'package:easypark/domain/model/model.dart';
import 'package:easypark/domain/usecase/base_usecase.dart';

class MyTransactionsUseCase extends BaseUseCase<String, List<Transaction>>{

  NetworkService  get networkService => instance<NetworkService>();
  @override
  Future<Either<Failure, List<Transaction>>> execute(String input) async{

    List<Transaction> allTransactions = [];
    final response = await networkService.makeStringGetRequest(
        {}, BASE_URL + "/customer/account/transactions", true);

    if(response.error){

      return left(Failure(200, response.errorMessage));

    }else{

      var jsonData = jsonDecode(response.data);

      var transactionsData = jsonData['data'] as List;

      transactionsData.forEach((transaction) {
        allTransactions.add(Transaction.fromJson(transaction));
      });

      return right(allTransactions);

    }
  }


}






