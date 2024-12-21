import 'dart:async';

import 'package:easypark/domain/model/model.dart';
import 'package:easypark/domain/usecase/deletevehicle_usecase.dart';
import 'package:easypark/domain/usecase/parkinghistory_usecase.dart';
import 'package:easypark/presentation/base/baseviewmodel.dart';
import 'package:easypark/presentation/common/state_renderer.dart';
import 'package:easypark/presentation/common/state_renderer_impl.dart';

class VehicleDetailsViewModel extends BaseViewModel with VehicleDetailsModelInputs, VehicleDetailsModelOutputs{
  StreamController _parkingHistoryStreamController = StreamController<List<ParkingHistory>>.broadcast();
  StreamController deleteVehicleStreamController= StreamController<bool>.broadcast();

  VehicleDetailsViewModel(this._useCase);

  ParkingHistoryUseCase _useCase;


  @override
  void getParkingHistory(String id, bool isAll) async{
    loadingStreamController.add(true);
    (await  _useCase.execute(ParkingHistoryUseCaseInput(id, isAll))).fold((l) {
      loadingStreamController.add(false);
      responseMessage  = l.message;
      messagesStreamController.add([false, responseMessage]);

    }, (r) {
      loadingStreamController.add(false);
      inputParkingHistory.add(r);
    });
  }

  @override
  // TODO: implement inputParkingHistory
  Sink get inputParkingHistory => _parkingHistoryStreamController.sink;

  @override
  void start() {
  }

  @override
  // TODO: implement outputParkingHistory
  Stream<List<ParkingHistory>> get outputParkingHistory => _parkingHistoryStreamController.stream.map((event) => event);

  @override
  void deleteVehicle(String carId) async{
      loadingStreamController.add(true);
      DeleteVehicleUseCase _deleteUseCase = new DeleteVehicleUseCase();

      (await _deleteUseCase.execute(DeleteVehicleUseCaseInput(carId))).fold((l) {
        loadingStreamController.add(false);
        responseMessage  = l.message;
        messagesStreamController.add([false, responseMessage]);
      }, (isSuccess){
        loadingStreamController.add(false);
        messagesStreamController.add([true, "Vehicle Deleted successfully"]);
        inputDeleteVehicle.add(isSuccess);

      });
    // TODO: implement deleteVehicle
  }

  @override
  // TODO: implement inputDeleteVehicle
  Sink get inputDeleteVehicle => deleteVehicleStreamController.sink;

  @override
  // TODO: implement outputDeleteVehicle
  Stream<bool> get outputDeleteVehicle => deleteVehicleStreamController.stream.map((event) => event);

}




abstract class VehicleDetailsModelInputs{
  Sink get inputParkingHistory;

  Sink get inputDeleteVehicle;


  void getParkingHistory(String vehicleId, bool isAll);

  void deleteVehicle(String carId);

}

abstract class VehicleDetailsModelOutputs{

  Stream<List<ParkingHistory>> get outputParkingHistory;

  Stream<bool> get outputDeleteVehicle;


}