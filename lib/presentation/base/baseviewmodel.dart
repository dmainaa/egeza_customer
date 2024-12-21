import 'dart:async';

import 'package:easypark/presentation/common/state_renderer_impl.dart';

abstract class BaseViewModel extends BaseViewModelInputs with BaseViewModelOutputs {

  StreamController<bool> responseStreamController = StreamController<bool>.broadcast();
  StreamController<bool> loadingStreamController = StreamController<bool>.broadcast();
  StreamController<List<dynamic>> messagesStreamController = StreamController<List<dynamic>>.broadcast();
  String responseMessage = "";
  String successMessage = "";


  @override
  void dispose() {
   responseStreamController.close();
   loadingStreamController.close();
   messagesStreamController.close();
  }

//shared variables and functions that will be used through any view model
}

abstract class BaseViewModelInputs {
  void start(); //called when initializing the view model
  void dispose(); //called when the view model dies
}

abstract class BaseViewModelOutputs {

}
