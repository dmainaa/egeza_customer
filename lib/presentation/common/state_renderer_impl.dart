

import 'package:easypark/presentation/common/state_renderer.dart';
import 'package:easypark/presentation/resources/string_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


abstract class FlowState{

  StateRendererType getStateRendererType();

  String getMessage();

  VoidCallback retry();
}

class LoadingState extends FlowState{

  StateRendererType stateRendererType;
  String message;


  LoadingState(this.stateRendererType, String? message):
    message = message ?? AppStrings.loading
  ;


  @override
  StateRendererType getStateRendererType() {
    return stateRendererType;
  }

  @override
  String getMessage() {
    return message;
  }

  @override
  VoidCallback retry() {
    // TODO: implement retry
    return (){

    };
  }


}

class ErrorState extends FlowState{

  StateRendererType stateRendererType;
  String message;
  VoidCallback? retryFunction;


  ErrorState(this.stateRendererType, this.message, {this.retryFunction});

  @override
  StateRendererType getStateRendererType() {
    return stateRendererType;
  }

  @override
  String getMessage() {
    return message;
  }

  @override
  VoidCallback retry() {
    print('Something went wrong');
    // TODO: implement retry;
    return retryFunction ?? (){
    };
  }
}

class ContentState extends FlowState {

  ContentState();

  @override
  StateRendererType getStateRendererType() {
    return StateRendererType.CONTENT_SCREEN_STATE;
  }

  @override
  String getMessage() {
    return "";
  }

  @override
  VoidCallback retry() {
    // TODO: implement retry
    return (){

    };
  }
}

class EmptyState extends FlowState {
  String message;
  EmptyState(this.message);

  @override
  StateRendererType getStateRendererType() {
    return StateRendererType.EMPTY_SCREEN_STATE;
  }

  @override
  String getMessage() {
    return message;
  }

  @override
  VoidCallback retry() {
    // TODO: implement retry
    return (){

    };
  }
}

class SuccessState extends FlowState {
  String message;
  SuccessState(this.message);

  @override
  StateRendererType getStateRendererType() {
    return StateRendererType.POPUP_SUCCESS;
  }

  @override
  String getMessage() {
    return message;
  }

  @override
  VoidCallback retry() {
    // TODO: implement retry
    return (){

    };
  }
}

extension FlowStateExtension on FlowState{
  Widget getScreenWidget(BuildContext context, Widget contentScreenWidget, VoidCallback retryActionFunction){
      switch(this.runtimeType){
        case LoadingState: {
          if(getStateRendererType() == StateRendererType.POPUP_LOADING_STATE){
            showPopUp(context, getStateRendererType(), getMessage());

            return contentScreenWidget;
          }else{
            return StateRenderer(stateRendererType: getStateRendererType(), message: getMessage(), retryActionFunction: retryActionFunction,);
          }

        }
        case ContentState: {
          // dismissDialog(context);
          return contentScreenWidget;
        }
        case ErrorState: {
          // dismissDialog(context);
          if(getStateRendererType() == StateRendererType.POPUP_ERROR_STATE){

            showPopUp(context, getStateRendererType(), getMessage(), retry: (){
              debugPrint("Clicked again");
              retry();
            });
            return contentScreenWidget;

          }else{

            return StateRenderer(stateRendererType: getStateRendererType(), message: getMessage(), retryActionFunction: retryActionFunction,);

          }

        }
        case SuccessState: {
          // dismissDialog(context);

          showPopUp(context, StateRendererType.POPUP_SUCCESS, getMessage(), title: AppStrings.success);

          return contentScreenWidget;


        }
        default: {
            return contentScreenWidget;
        }
      }
  }

  // dismissDialog(BuildContext context){
  //   if(_isThereCurrentDialogShowing(context)){
  //     Navigator.of(context, rootNavigator: true).pop(true);
  //   }
  // }
  _isThereCurrentDialogShowing(BuildContext context)=> ModalRoute.of(context)?.isCurrent != true;

  showPopUp(BuildContext context, StateRendererType stateRendererType, String message, {String title = "", VoidCallback? retry}){

    WidgetsBinding.instance.addPostFrameCallback((_) => showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => StateRenderer(
            stateRendererType: stateRendererType,
            message: message,
            title: title,
            retryActionFunction: (){
              // dismissDialog(context);
              // retry!();
            }
    ) ));
  }
}
