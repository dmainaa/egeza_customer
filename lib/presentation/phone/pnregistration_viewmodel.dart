import 'dart:async';
import 'dart:ffi';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:easypark/domain/usecase/verify_phone.dart';
import 'package:easypark/presentation/base/baseviewmodel.dart';
import 'package:easypark/presentation/common/state_renderer.dart';
import 'package:easypark/presentation/common/state_renderer_impl.dart';

class PNRegistrationViewModel extends BaseViewModel with PNRegistrationViewModelInputs, PNRegistrationViewModelOutputs{

   StreamController _allInputIsValidController = StreamController<void>.broadcast();

   StreamController _phoneStreamController = StreamController<void>.broadcast();

   StreamController _codeStreamController = StreamController<String>.broadcast();

   StreamController registerStreamController = StreamController<bool>.broadcast();

  String enteredPhone = "";

  String countryCode = "+254";

  VerifyPhone verifyPhoneUseCase;


  PNRegistrationViewModel(this.verifyPhoneUseCase);

  bool isPhoneNumberValid(String phone){

    return phone.length == 9;

  }
  
  _validate(){
    inputPhone.add(enteredPhone);
    inputIsAllInputValid.add(null);
  }


  @override
  // TODO: implement inputIsAllInputValid
  Sink get inputIsAllInputValid {

    return _allInputIsValidController.sink;

  }

  @override
  void dispose(){
    print("Dispose 2 called");
    _phoneStreamController.close;
    _allInputIsValidController.close();
    _codeStreamController.close();
    registerStreamController.close();
  }

  @override
  Sink get inputPhone {
    return _phoneStreamController.sink;
  }


  @override

  Stream<bool> get outputIsAllInputValid {
    print("I have been called");
    return _allInputIsValidController.stream.map((_) => isPhoneNumberValid(enteredPhone));
  }

  @override

  Stream<bool> get outputIsPhoneValid {
    return _phoneStreamController.stream.map((_) => isPhoneNumberValid(_));
  }

  @override
  register() async {
    print(enteredPhone);

    // // TODO: implement requestOtp
    loadingStreamController.add(true);
    (await verifyPhoneUseCase
            .execute(VerifyPhoneBaseInput(enteredPhone, countryCode)))
        .fold(
            (failure) => {
                  loadingStreamController.add(false),
                  responseMessage = failure.message,
                  messagesStreamController.add([false, responseMessage])
                },
            (userExists) => {
                  loadingStreamController.add(false),
                  inputUserExists.add(userExists),
                });
  }

  @override
  setPhoneNumber(String phone) {
    enteredPhone = phone;
    print("Entered phone $enteredPhone");
    _validate();


  }





  @override
  void start() {
    // TODO: implement start
  }

  @override
  setCountryCode(String countryCode) {
    // TODO: implement setCountryCode
    countryCode = countryCode;
    inputCountryCode.add(countryCode);
    _validate();
  }

  @override
  // TODO: implement inputCountryCode
  Sink get inputCountryCode {
    return _codeStreamController.sink;
  }

  @override
  // TODO: implement outputCountryCode
  Stream<String> get outputCountryCode {

    return _codeStreamController.stream.map((event) => countryCode);
  }

  @override
  // TODO: implement inputUserExists
  Sink get inputUserExists {
    return registerStreamController.sink;
  }

  @override
  // TODO: implement outputUserExists
  Stream<bool> get outputUserExists {
    return registerStreamController.stream.map((userExists) => userExists);
  }

}


abstract class PNRegistrationViewModelInputs{

  setPhoneNumber(String phone);

  setCountryCode(String countryCode);

  register();

  Sink get inputPhone;



  Sink get inputIsAllInputValid;

  Sink get inputCountryCode;

  Sink get inputUserExists;
}

abstract class PNRegistrationViewModelOutputs{
  Stream<bool> get outputIsPhoneValid;
  Stream<bool> get outputIsAllInputValid;
  Stream<bool> get outputUserExists;
  Stream<String> get outputCountryCode;
}