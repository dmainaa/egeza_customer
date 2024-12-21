import 'package:dartz/dartz.dart';
import 'package:easypark/app/constants.dart';
import 'package:easypark/app/di.dart';
import 'package:easypark/data/network/failure.dart';
import 'package:easypark/data/network/network_service.dart';
import 'package:easypark/domain/usecase/base_usecase.dart';


class LogOutUseCase extends BaseUseCase<String, bool>{

  NetworkService get networkService => instance<NetworkService>();
  @override
  Future<Either<Failure, bool>> execute(String input) async{
    final response = await networkService.makeStringGetRequest(
        {}, BASE_URL + "/logout", true);

    if(response.error){
      return left(Failure(200, response.errorMessage));
    }else{

      return right(true);
    }
  }

}




