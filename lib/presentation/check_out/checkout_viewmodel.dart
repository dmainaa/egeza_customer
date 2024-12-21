
import 'dart:async';

import 'package:easypark/domain/usecase/checkout_usecase.dart';
import 'package:easypark/domain/usecase/makepayment_usecase.dart';
import 'package:easypark/presentation/base/baseviewmodel.dart';
import 'package:easypark/presentation/common/state_renderer.dart';
import 'package:easypark/presentation/common/state_renderer_impl.dart';

class CheckOutViewModel extends BaseViewModel with CheckoutViewModelInputs, CheckOutViewModelOutputs{

  StreamController checkoutStreamController = StreamController.broadcast();


  @override
  checkOut(String session_ID) async{

    CheckOutUseCase _useCase = CheckOutUseCase();
    loadingStreamController.add(true);
    // inputState.add(LoadingState(StateRendererType.POPUP_LOADING_STATE, "Checking Out..."));

    (await _useCase.execute(CheckOutUseCaseInputs(session_ID))).fold((l){
      loadingStreamController.add(false);
      responseMessage = l.message;
      responseStreamController.add(false);
    }, (r) {
      loadingStreamController.add(false);
      inputCheckoutSession.add(r);
    });
  }



  @override
  // TODO: implement inputCheckoutSession
  Sink get inputCheckoutSession => checkoutStreamController.sink;

  @override
  // TODO: implement outputGetSessions
  Stream<String> get outputGetSessions => checkoutStreamController.stream.map((event) => event);

  @override
  void start() {
    // TODO: implement start
  }

}

abstract class CheckoutViewModelInputs {
  checkOut(String session_ID);
  Sink get inputCheckoutSession;
}

abstract class CheckOutViewModelOutputs {
  Stream<String> get outputGetSessions;
}