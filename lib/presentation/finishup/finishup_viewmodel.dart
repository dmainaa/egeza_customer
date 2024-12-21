
import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:dartz/dartz_streaming.dart';
import 'package:easypark/app/app_utils.dart';
import 'package:easypark/app/di.dart';
import 'package:easypark/domain/usecase/finish_up.dart';
import 'package:easypark/presentation/base/baseviewmodel.dart';
import 'package:easypark/presentation/common/state_renderer.dart';
import 'package:easypark/presentation/common/state_renderer_impl.dart';
import 'package:easypark/presentation/resources/string_manager.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
class FinishUpViewModel extends BaseViewModel with FinishUpViewModelInputs, FinishUpViewModelOutputs{
  StreamController _allInputIsValidController = StreamController<void>.broadcast();

  StreamController _emailIsValidController = StreamController<String>.broadcast();

  StreamController _firstNameIsValidController = StreamController<String>.broadcast();

  StreamController _lastNameIsValidController = StreamController<String>.broadcast();

  StreamController finishUpStreamController = StreamController<bool>.broadcast();

  StreamController cropFileStreamController = StreamController<void>.broadcast();

  FinishUpUseCase _useCase;


  FinishUpViewModel(this._useCase);

  CroppedFile? profilePic;
  String firstName = "";
  String lastName = "";
  String email = "";

  AppUtils get appUtils => instance<AppUtils>();



  _validate(){
      inputFirstName.add(firstName);
      inputLastName.add(lastName);
      inputEmail.add(email);
      inputIsAllInputValid.add(null);
  }

  bool validateEmail(String email){
    bool isValid =  appUtils.validateEmail(email);

    debugPrint("Is valid email? $isValid" );

    return isValid;
  }

  bool validateFirstName(String firstName){
    return firstName.isEmpty;
  }

  bool validateLastName(String lastName){
    return lastName.isEmpty;
  }

  bool validateAll(){
    return validateEmail(email) && !validateLastName(lastName) && !validateFirstName(firstName);
  }


  @override
  finishUp() async {
    loadingStreamController.add(true);
    (await _useCase.execute(FinishUpUseCaseInputs(firstName, lastName,  email, getStringImage64String()))).fold(
            (l) {
              loadingStreamController.add(false);
              responseMessage = l.message;
              messagesStreamController.add([false, responseMessage]);
            },
            (r) {
              loadingStreamController.add(false);
              finishUpComplete.add(true);
            }
    );
  }

  @override
  // TODO: implement finishUpComplete
  Sink get finishUpComplete {
    return finishUpStreamController.sink;
  }

  @override
  // TODO: implement inputEmail
  Sink get inputEmail {
    return _emailIsValidController.sink;
  }

  @override
  // TODO: implement inputFile
  Sink get inputFile {
    return cropFileStreamController.sink;
  }

  @override
  // TODO: implement inputFirstName
  Sink get inputFirstName{
    return _firstNameIsValidController.sink;
  }

  @override
  // TODO: implement inputIsAllInputValid
  Sink get inputIsAllInputValid {
    return _allInputIsValidController.sink;
  }

  @override
  // TODO: implement inputLastName
  Sink get inputLastName {
    return _lastNameIsValidController.sink;
  }

  @override
  // TODO: implement outputEmailIsValid
  Stream<String> get outputEmailIsValid {
    return _emailIsValidController.stream.map((email){
      if(validateEmail(email)){
        return "";
      }else {
        return AppStrings.enterValidEmail;
      }
    });
  }

  @override
  // TODO: implement outputIsLastNameValid
  Stream<bool> get outputIsLastNameValid {
    return _lastNameIsValidController.stream.map((lastName) => validateLastName(lastName));
  }

  @override
  // TODO: implement outputFinishUpComplete
  Stream<bool> get outputFinishUpComplete => throw UnimplementedError();

  @override
  // TODO: implement outputIsAllInputValid
  Stream<bool> get outputIsAllInputValid {
      return _allInputIsValidController.stream.map((event) => validateAll());
  }

  @override
  // TODO: implement outputIsPhoneValid
  Stream<bool> get outputIsFirstNameValid {
    return _firstNameIsValidController.stream.map((firstName) => validateFirstName(firstName));
  }

  @override
  setEmail(String email) {
    this.email = email;
    debugPrint(email);
    _validate();
  }

  @override
  setFirstName(String firstName) {
    this.firstName = firstName;

    _validate();
  }

  @override
  setLastName(String lastName) {
    this.lastName = lastName;
    _validate();
  }

  @override
  void start() {
  }

  @override
  // TODO: implement inputCroppedFile
  Sink get inputCroppedFile {
    return cropFileStreamController.sink;
  }

  @override
  // TODO: implement outputCroppedFile
  Stream<String> get outputCroppedFile {
    return cropFileStreamController.stream.map((event) => profilePic?.path ?? "");
  }

  @override
  setFile(CroppedFile? file) {
    // TODO: implement setFile
    this.profilePic = file;
    print("Profile pic path: ${profilePic?.path}");
    inputFile.add(null);

  }

  String getStringImage64String(){
    String path = profilePic?.path ?? "";
    if(path.isEmpty){
      return "";
    }else{
      final bytes = File(path).readAsBytesSync();
      String base64Image = base64Encode(bytes);
      return base64Image;
    }

  }



}




abstract class FinishUpViewModelInputs{

  setFirstName(String firstName);

  setLastName(String lastName);

  setEmail(String email);

  setFile(CroppedFile? file);



  finishUp();

  Sink get inputFirstName;

  Sink get inputIsAllInputValid;

  Sink get inputLastName;

  Sink get inputCroppedFile;

  Sink get inputEmail;

  Sink get inputFile;

  Sink get finishUpComplete;
}

abstract class FinishUpViewModelOutputs{
  Stream<bool> get outputIsFirstNameValid;
  Stream<bool> get outputIsLastNameValid;
  Stream<bool> get outputIsAllInputValid;
  Stream<bool> get outputFinishUpComplete;
  Stream<String> get outputEmailIsValid;
  Stream<String> get outputCroppedFile;
}