import 'package:dartz/dartz.dart';
import 'package:easypark/app/constants.dart';
import 'package:easypark/app/di.dart';
import 'package:easypark/data/network/failure.dart';
import 'package:easypark/data/network/network_service.dart';
import 'package:easypark/domain/usecase/base_usecase.dart';
import 'package:easypark/domain/usecase/deletevehicle_usecase.dart';

class DeleteVehicleUseCase extends BaseUseCase<DeleteVehicleUseCaseInput, bool>{
  NetworkService  get networkService => instance<NetworkService>();
  @override
  Future<Either<Failure, bool>> execute(DeleteVehicleUseCaseInput input) async {


    final response = await networkService.makeStringDeleteRequest(
        {}, BASE_URL + "/customer/vehicles/${input.carId}", true);

    if(response.error){
      return left(Failure(200, response.errorMessage));
    }else{

      return right(true);
    }
  }

}




class DeleteVehicleUseCaseInput{
  String carId;

  DeleteVehicleUseCaseInput(this.carId);
}