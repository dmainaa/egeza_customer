import 'dart:async';

import 'package:easypark/domain/usecase/verify_otp.dart';
import 'package:easypark/presentation/base/baseviewmodel.dart';


class OTPViewModel extends BaseViewModel with OTPViewModelInputs, OTPViewModelOutputs{
  StreamController otpStreamController = StreamController<String>.broadcast();
  StreamController otpVerifiedStreamController = StreamController<bool>.broadcast();
  StreamController _otpValidController = StreamController<String>.broadcast();

  String? _enteredOtp;


  String theOtp = "";

  VerifyOTPUseCase _useCase;


  OTPViewModel(this._useCase);

  bool _isOTPValid(String otp){

    bool isCorrect = _enteredOtp?.length == 6;

    return isCorrect;
  }

  @override
  // TODO: implement inputOTPVerified
  Sink get inputOTPVerified {
    return otpVerifiedStreamController.sink;
  }

  @override
  // TODO: implement isOTPValid
  Sink get isOTPValid {
    return otpStreamController.sink;
  }

  @override
  // TODO: implement outputOTPSuccessfullyVerified
  Stream<bool> get outputOTPSuccessfullyVerified {
    return otpVerifiedStreamController.stream.map((event){
      print("Called");
      return event;
    });
  }

  @override
  // TODO: implement outputOTPValid
  Stream<bool> get outputOTPValid{
    return otpStreamController.stream.map((otp){
      print('OTP $otp');
      theOtp = otp;
      return _isOTPValid(otp);
    });
  }

  @override
  setOtp(String otp) {
    _enteredOtp = otp.toString();

    inputOTPIsValid.add(_enteredOtp);
  }

  @override
  void start() {
    // TODO: implement start
  }

  @override
  verifyOtp(String otp) async{
    print("Entered otp $_enteredOtp");
    loadingStreamController.add(true);
    (await _useCase.execute(VerifyOTPUsecaseInput(_enteredOtp ?? "123456"))).fold((l) {
      loadingStreamController.add(false);
      responseMessage = l.message;
      messagesStreamController.add([false, responseMessage]);

    }, (r) {
      loadingStreamController.add(false);
      inputOTPVerified.add(r);
    });
  }

  @override
  // TODO: implement inputOTPIsValid
  Sink get inputOTPIsValid {
    return _otpValidController.sink;
  }

  @override
  // TODO: implement outputIsOTPValid
  Stream<bool> get outputIsOTPValid {
    return _otpValidController.stream.map((event){
      return _isOTPValid(event.toString());
    });
  }

}


abstract class OTPViewModelInputs{
  setOtp(String otp);

  verifyOtp(String otp);

  Sink get isOTPValid;
  Sink get inputOTPVerified;
  Sink get inputOTPIsValid;

}

abstract class OTPViewModelOutputs{
  Stream<bool> get outputOTPValid;
  Stream<bool> get outputIsOTPValid;
  Stream<bool> get outputOTPSuccessfullyVerified;
}