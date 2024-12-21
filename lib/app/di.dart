//

import 'package:easypark/app/app_utils.dart';
import 'package:easypark/data/network/dio_factory.dart';
import 'package:easypark/data/network/network_service.dart';
import 'package:easypark/domain/usecase/confirmpayment_usecase.dart';
import 'package:easypark/domain/usecase/finish_up.dart';
import 'package:easypark/domain/usecase/makepayment_usecase.dart';
import 'package:easypark/domain/usecase/verify_otp.dart';
import 'package:easypark/domain/usecase/verify_phone.dart';
import 'package:easypark/presentation/finishup/finishup_viewmodel.dart';
import 'package:easypark/presentation/otp/otp_viewmodel.dart';
import 'package:easypark/presentation/phone/pnregistration_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';



final instance = GetIt.instance;
Future<void> initAppModule()async{

  final sharedPreferences =  await SharedPreferences.getInstance();

  //shared preferences instance
  instance.registerLazySingleton<SharedPreferences>(() => sharedPreferences);


  //network service instance
  instance.registerLazySingleton<NetworkService>(() => NetworkService());

  instance.registerLazySingleton<AppUtils>(() => AppUtils());

  instance.registerLazySingleton<DioFactory>(() => DioFactory(instance()));

  instance.registerLazySingleton<ConfirmPaymentUseCase>(() => ConfirmPaymentUseCase());


  //
  // initLoginModule();

}


initLoginModule(){

  if(!GetIt.I.isRegistered<VerifyPhone>()){
    instance.registerLazySingleton<VerifyPhone>(() => VerifyPhone());
    instance.registerLazySingleton<VerifyOTPUseCase>(() => VerifyOTPUseCase());
    instance.registerLazySingleton<PNRegistrationViewModel>(() => PNRegistrationViewModel(instance()));
    instance.registerLazySingleton<OTPViewModel>(() => OTPViewModel(instance()));
    instance.registerLazySingleton<FinishUpUseCase>(() => FinishUpUseCase());
    instance.registerLazySingleton<ConfirmPaymentUseCase>(() => ConfirmPaymentUseCase());
    instance.registerLazySingleton<FinishUpViewModel>(() => FinishUpViewModel(instance()));
  }


}

