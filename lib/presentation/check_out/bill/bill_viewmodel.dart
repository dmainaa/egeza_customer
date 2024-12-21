import 'dart:async';

import 'package:easypark/app/di.dart';
import 'package:easypark/domain/model/model.dart';
import 'package:easypark/domain/usecase/bill_usecase.dart';
import 'package:easypark/domain/usecase/confirmpayment_usecase.dart';
import 'package:easypark/domain/usecase/makepayment_usecase.dart';
import 'package:easypark/presentation/base/baseviewmodel.dart';
import 'package:easypark/presentation/common/state_renderer.dart';
import 'package:easypark/presentation/common/state_renderer_impl.dart';

class BillViewModel extends BaseViewModel with BillViewModelInputs, BillViewModelOutputs{

  StreamController billStreamController = StreamController<Bill>.broadcast();

  StreamController selectedStreamController = StreamController<int>.broadcast();

  StreamController makePaymentStreamControler = StreamController<PaymentStatus>.broadcast();

  StreamController isPaymentConfirmedStreamController = StreamController<bool>.broadcast();

  BillUseCase _useCase;

  late Timer timer;

   ConfirmPaymentUseCase get confirmPaymentUseCase => instance<ConfirmPaymentUseCase>();

  BillViewModel(this._useCase);

  @override
  getBill(String billId) async{
    loadingStreamController.add(true);
    (await _useCase.execute(BillUseCaseInputs(billId))).fold((l){
      loadingStreamController.add(false);
      messagesStreamController.add([false, ""]);
    }, (r){
      loadingStreamController.add(false);
      inputGetBill.add(r);
    });
  }

  @override
  // TODO: implement inputGetBill
  Sink get inputGetBill => billStreamController.sink;

  @override
  // TODO: implement outputGetBill
  Stream<Bill> get outputGetBill => billStreamController.stream.map((event) => event);

  @override
  void start() {
    // TODO: implement start
    loadingStreamController.add(true);
  }

  void setSelected(int id){
    inputSelected.add(id);
  }

  void makePayment(String billId, String paymentMethodId, String clientId)async{

    MakePaymentUseCase makePaymentUseCase = MakePaymentUseCase();
    loadingStreamController.add(true);

    (await makePaymentUseCase.execute(MakePaymentUseCaseInputs(billId, paymentMethodId, clientId))).fold(
            (l) {
              loadingStreamController.add(false);
              responseMessage  = l.message;
              responseStreamController.add(true);
            },
            (r) {
              loadingStreamController.add(false);
              inputMakePayment.add(r);
        }
    );
  }

  void confirmPayment(String billId, String paymentMethodId, String clientId)async{


    timer = Timer.periodic(const Duration(seconds: 2), (timer) async{
      (await confirmPaymentUseCase.execute(ConfirmPaymentUseCaseInputs(billId, paymentMethodId, clientId))).fold((l) {
        responseMessage  = l.message;
        responseStreamController.add(true);
        timer.cancel();
      } ,
      (r) {

        String status = r;

        print("Status is $status");

        if(status == "failed"){
          timer.cancel();
          isPaymentConfirmed.add(false);

        }else if(status == "paid"){
          timer.cancel();
          isPaymentConfirmed.add(true);
        }

      }
      );
    });

  }

  @override
  void dispose() {
    timer.cancel();
    billStreamController.close();
    // TODO: implement start
  }

  @override
  // TODO: implement inputSelected
  Sink get inputSelected => selectedStreamController.sink;

  @override
  // TODO: implement outputSelected
  Stream<int> get outputSelected => selectedStreamController.stream.map((event) => event);

  @override
  // TODO: implement inputMakePayment
  Sink get inputMakePayment => makePaymentStreamControler.sink;

  @override
  // TODO: implement outputMakePayment
  Stream<PaymentStatus> get outputMakePayment => makePaymentStreamControler.stream.map((event) => event);

  @override
  // TODO: implement isPaymentConfirmed
  Sink get isPaymentConfirmed => isPaymentConfirmedStreamController.sink;

  @override
  // TODO: implement outputisPaymentConfirmed
  Stream<bool> get outputisPaymentConfirmed => isPaymentConfirmedStreamController.stream.map((event) => event);

}


abstract class BillViewModelInputs{

  getBill(String billId);

  Sink get inputGetBill;

  Sink get inputSelected;

  Sink get inputMakePayment;

  Sink get isPaymentConfirmed;


}

abstract class BillViewModelOutputs{

  Stream<Bill> get outputGetBill;

  Stream<int> get outputSelected;

  Stream<bool> get outputisPaymentConfirmed;

  Stream<PaymentStatus> get outputMakePayment;

}