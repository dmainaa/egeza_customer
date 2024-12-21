
import 'dart:async';

import 'package:easypark/domain/model/model.dart';
import 'package:easypark/domain/usecase/promotions_usecase.dart';
import 'package:easypark/domain/usecase/redeempromotion_usecase.dart';
import 'package:easypark/presentation/base/baseviewmodel.dart';
import 'package:easypark/presentation/common/state_renderer.dart';
import 'package:easypark/presentation/common/state_renderer_impl.dart';
import 'package:easypark/presentation/promotions/promotions_viewmodel.dart';
class PromotionsViewModel extends BaseViewModel with PromotionsViewModelInputs, PromotionsViewModelOutputs{
  StreamController promotionsStreamController = StreamController<List<Promotion>>.broadcast();
  StreamController redeemCodeStreamController = StreamController<bool>.broadcast();

  PromotionsUseCase _useCase;


  PromotionsViewModel(this._useCase);

  @override
  // TODO: implement inputRedeemCode
  Sink get inputRedeemCode => redeemCodeStreamController.sink;

  @override
  // TODO: implement inputgetPromotions
  Sink get inputgetPromotions => promotionsStreamController.sink;

  @override
  // TODO: implement outputGetPromotions
  Stream<List<Promotion>> get outputGetPromotions => promotionsStreamController.stream.map((event) => event);

  @override
  // TODO: implement outputRedeemCode
  Stream<bool> get outputRedeemCode => redeemCodeStreamController.stream.map((event) => event);
  @override
  void dispose(){
    promotionsStreamController.close();
    redeemCodeStreamController.close();
  }

  @override
  redeemCode(String code) async{

    loadingStreamController.add(true);

    RedeemPromotionUsecase useCase = RedeemPromotionUsecase();

    (await useCase.execute(RedeemPromotionUseCaseInput(code))).fold((l) {
      loadingStreamController.add(false);
      responseMessage  = l.message;
      messagesStreamController.add([false, responseMessage]);
      responseStreamController.add(true);

    }, (r) {
      loadingStreamController.add(false);
      inputRedeemCode.add(r);
      if(r){
        getPromotions();
      }
    });
  }

  @override
  void start() {
    // TODO: implement start
  }

  @override
  getPromotions() async{
    loadingStreamController.add(true);
    (await _useCase.execute("")).fold((l) {
      loadingStreamController.add(false);
      responseMessage  = l.message;
      responseStreamController.add(true);
    }, (r) {
      loadingStreamController.add(false);
      inputgetPromotions.add(r);
    });
  }

}


abstract class PromotionsViewModelInputs{

  redeemCode(String code);
  getPromotions();
  Sink get inputRedeemCode;
  Sink get inputgetPromotions;

}

abstract class PromotionsViewModelOutputs{
  Stream<bool> get outputRedeemCode;
  Stream<List<Promotion>> get outputGetPromotions;

}