


import 'dart:async';
import 'dart:ffi';

import 'package:easypark/domain/model/model.dart';
import 'package:easypark/domain/usecase/myvehicles_usecase.dart';
import 'package:easypark/domain/usecase/register_vehicle_usecase.dart';
import 'package:easypark/presentation/base/baseviewmodel.dart';
import 'package:easypark/presentation/common/state_renderer.dart';
import 'package:easypark/presentation/common/state_renderer_impl.dart';


class MyVehiclesViewModel extends BaseViewModel with MyVehicleModelInputs, MyVehicleModelOutputs{

  StreamController myVehiclesStreamController = StreamController<List<Vehicle>>.broadcast();
  StreamController registerVehicleStreamController = StreamController<bool>.broadcast();
  StreamController isVehicleRegisteredSuccessfully = StreamController<bool>.broadcast();
  StreamController _isPlateValidStreamController = StreamController<String>.broadcast();
  StreamController showLoaderController = StreamController<bool>.broadcast();

  MyVehiclesUseCase _useCase;

  String plateNumber = "";

  MyVehiclesViewModel(this._useCase);

  @override
  void getMyVehicles() async {
    // TODO: implement getMyVehicles
    loadingStreamController.add(true);
    (await _useCase.execute(null)).fold((l) {
      loadingStreamController.add(false);
      messagesStreamController.add([false, l.message]);
    }, (r) {
      loadingStreamController.add(false);
      List<Vehicle> myVehicles = r;
      myVehicles.forEach((vehicle) {
        print(vehicle.title);
      });
      inputMyVehicles.add(myVehicles);
    });
  }

  bool _validatePlate(String plate){
    return plate.isNotEmpty;
  }



  @override
  // TODO: implement inputMyVehicles
  Sink get inputMyVehicles => myVehiclesStreamController.sink;

  @override
  // TODO: implement outputMyVehicles
  Stream<List<Vehicle>> get outputMyVehicles => myVehiclesStreamController.stream.map((event) => event);

  @override
  void start() {
  }

  @override
  void dispose(){
    myVehiclesStreamController.close();
  }

  @override
  // TODO: implement inputRegisterVehicle
  Sink get inputRegisterVehicle => registerVehicleStreamController.sink;

  @override
  // TODO: implement outputRegisterVehicle
  Stream<bool> get outputRegisterVehicle => registerVehicleStreamController.stream.map((event) => event);

  @override
  void registerVehicle(String plateNumber) async{
    loadingStreamController.add(true);

    RegisterVehicleUsecase _regUseCase = new RegisterVehicleUsecase();

    (await  _regUseCase.execute(RegisterVehicleUseCaseInputs(plateNumber))).fold((l) {
      loadingStreamController.add(false);
      responseMessage  = l.message;
      messagesStreamController.add([false, responseMessage]);

    }, (r) {
      loadingStreamController.add(false);
      inputIsVehicleregisteredSuccessfully.add(r);

    });

    // TODO: implement registerVehicle
  }

  @override
  // TODO: implement inputIsPlateNumberValid
  Sink get inputIsPlateNumberValid => _isPlateValidStreamController.sink;


  @override
  void setPlateNumber(String plate) {
    // TODO: implement setPlateNumber
    plateNumber = plate;
    inputIsPlateNumberValid.add(plateNumber);
  }

  @override
  // TODO: implement outputIsPlateNumberValid
  Stream<bool> get outputIsPlateNumberValid => _isPlateValidStreamController.stream.map((plate) => _validatePlate(plate));

  @override
  // TODO: implement inputIsVehicleregisteredSuccessfully
  Sink get inputIsVehicleregisteredSuccessfully => isVehicleRegisteredSuccessfully.sink;

  @override
  // TODO: implement inputShowLoader
  Sink get inputShowLoader {
    return showLoaderController.sink;
  }

  @override
  // TODO: implement outputShowLoader
  Stream<bool> get outputShowLoader {
    return showLoaderController.stream.map((event) => event);
  }

}

abstract class MyVehicleModelInputs{
  Sink get inputMyVehicles;
  Sink get inputRegisterVehicle;

  Sink get inputIsPlateNumberValid;

  Sink get inputIsVehicleregisteredSuccessfully;

  Sink get inputShowLoader;

  void getMyVehicles();

  void setPlateNumber(String plate);
  void registerVehicle(String plateNumber);
}

abstract class MyVehicleModelOutputs{
  Stream<List<Vehicle>> get outputMyVehicles;

  Stream<bool> get outputRegisterVehicle;

  Stream<bool> get outputIsPlateNumberValid;

  Stream<bool> get outputShowLoader;
}