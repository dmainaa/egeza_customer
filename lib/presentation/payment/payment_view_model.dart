

import 'dart:async';
import 'dart:ffi';

import 'package:easypark/domain/model/model.dart';
import 'package:easypark/domain/usecase/myaccount_usecase.dart';
import 'package:easypark/presentation/base/baseviewmodel.dart';
import 'package:easypark/presentation/common/state_renderer.dart';
import 'package:easypark/presentation/common/state_renderer_impl.dart';
class PaymentViewModel extends BaseViewModel with PaymentViewModelInputs, PaymentViewModelOutputs{

  StreamController accountDetailsStreamController = StreamController<MyAccount>.broadcast();

  MyAccountUseCase _useCase;


  PaymentViewModel(this._useCase);

  @override
  getAccountDetails() async{

    (await _useCase.execute("")).fold((l){
      messagesStreamController.add([false, l.message]);

    }, (r){
      inputgetAccountDetails.add(r);
    });


  }

  @override
  // TODO: implement inputgetAccountDetails
  Sink get inputgetAccountDetails => accountDetailsStreamController.sink;

  @override
  // TODO: implement outputgetAccountDetails
  Stream<MyAccount> get outputgetAccountDetails => accountDetailsStreamController.stream.map((event) => event);

  @override
  void start() {
    // TODO: implement start
  }

  @override
  void dispose(){
    accountDetailsStreamController.close();
  }
}



abstract class PaymentViewModelInputs{
  getAccountDetails();

  Sink get inputgetAccountDetails;

}

abstract class PaymentViewModelOutputs{
  Stream<MyAccount> get outputgetAccountDetails;

}