import 'package:easypark/data/network/failure.dart';
import 'package:easypark/presentation/resources/assets_manager.dart';
import 'package:easypark/presentation/resources/color_manager.dart';
import 'package:easypark/presentation/resources/font_manager.dart';
import 'package:easypark/presentation/resources/string_manager.dart';
import 'package:easypark/presentation/resources/style_manager.dart';
import 'package:easypark/presentation/resources/value_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';


enum StateRendererType{
  //POPUP STATES
  POPUP_LOADING_STATE,
  POPUP_ERROR_STATE,
  POPUP_SUCCESS,

  //FULLSCREEN STATES
  FULL_SCREEN_LOADING_STATE,
  FULL_SCREEN_ERROR_STATE,

  CONTENT_SCREEN_STATE, //THE UI OF THE SCREEN
  EMPTY_SCREEN_STATE    // EMPTY VIEW WHEN WE RECEIVE NO DATA FROM API SIDE FOR LIST SCREEN

}

class StateRenderer extends StatelessWidget{
  StateRendererType?  stateRendererType;


  String message;
  String title;
  VoidCallback? retryActionFunction;


  StateRenderer({Key? key,  this.stateRendererType, Failure? failure, String? message, String? title,
    this.retryActionFunction}) :
      message = message ?? AppStrings.dismiss,
      title = title ?? "",


        super(key: key);

  @override
  Widget build(BuildContext context) {
    return _getStateWidget(context);
  }

  Widget _getStateWidget(BuildContext context) {
    switch (stateRendererType) {
      case StateRendererType.POPUP_LOADING_STATE:
        return _getPopUpDialog(context, [_getAnimatedImage(JsonAssets.loading)]);
      case StateRendererType.POPUP_ERROR_STATE:
        return _getPopUpDialog(context, [_getAnimatedImage(JsonAssets.error), _getMessage( message), _getRetryButton(AppStrings.ok, context)]);
      case StateRendererType.FULL_SCREEN_LOADING_STATE:
       return  _getItemsInColumn([_getAnimatedImage(JsonAssets.loading), _getMessage(message)]);

      case StateRendererType.POPUP_SUCCESS:
        return _getPopUpDialog(context, [_getAnimatedImage(JsonAssets.success), _getMessage( message), _getRetryButton(AppStrings.dismiss, context)]);
      // TODO: Handle this case.

      case StateRendererType.FULL_SCREEN_ERROR_STATE:
      // TODO: Handle this case.
        return  _getItemsInColumn([_getAnimatedImage(JsonAssets.error), _getMessage(message), _getRetryButton(AppStrings.ok, context)]);
      case StateRendererType.CONTENT_SCREEN_STATE:
      return Container();
      case StateRendererType.EMPTY_SCREEN_STATE:
        return  _getItemsInColumn([_getAnimatedImage(JsonAssets.empty), _getMessage(message)]);
      default:
        return Container();
    }
  }
  Widget _getAnimatedImage(String animationName){
    return SizedBox(
      height: AppSize.s100,
      width: AppSize.s100,
      child: Lottie.asset(animationName),
    );
  }

  Widget _getRetryButton(String buttonTitle, BuildContext context){
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppPadding.p18),
        child: SizedBox(
          width: AppSize.s180 ,
          child: ElevatedButton(
              onPressed: retryActionFunction!

          , child: Text(buttonTitle, style: const TextStyle(color: Colors.white),)),
        ),
      ),
    );
  }

  Widget _getMessage(String message){
    return Center(child: Text(message, style: getMediumStyle(color: AppColors.blackShade, fontSize: FontSize.s16)));
  }
  Widget _getItemsInColumn(List<Widget> children){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: children,
      ),
    );
  }
}

Widget _getPopUpDialog(BuildContext context, List<Widget> children) {
  return Dialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppSize.s14),

    ),
    elevation: AppSize.s1_5,

    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(AppSize.s14),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: AppSize.s12, offset: Offset(AppSize.s0, AppSize.s12))],),
      child: _getDialogContent(context, children),
    ),

  );
}

Widget _getDialogContent(BuildContext context, List<Widget> children){
  return Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: children,
  );
}