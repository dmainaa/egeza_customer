
import 'dart:async';

import 'package:easypark/domain/model/model.dart';
import 'package:easypark/domain/usecase/mytransactions_usecase.dart';
import 'package:easypark/presentation/base/baseviewmodel.dart';
import 'package:easypark/presentation/common/state_renderer.dart';
import 'package:easypark/presentation/common/state_renderer_impl.dart';

class TransactionViewModel extends BaseViewModel with TransactionViewModelInputs, TransactionViewModelOutputs{

  StreamController _transactionsStreamController = StreamController<List<Transaction>>.broadcast();

  MyTransactionsUseCase _useCase;


  TransactionViewModel(this._useCase);

  @override
  void getTransactions() async{
    loadingStreamController.add(true);
    (await _useCase.execute("")).fold((l){
      loadingStreamController.add(false);
      responseMessage  = l.message;
      responseStreamController.add(true);
    }, (r) {
      loadingStreamController.add(false);
      inputgetTransactions.add(r);
    });
  }

  @override
  // TODO: implement inputgetTransactions
  Sink get inputgetTransactions => _transactionsStreamController.sink;

  @override
  // TODO: implement outputgetTransactions
  Stream<List<Transaction>> get outputgetTransactions => _transactionsStreamController.stream.map((event) => event);

  @override
  void start() {
    // TODO: implement start
  }

  @override
  void dispose(){
    _transactionsStreamController.close();
  }


}



abstract class TransactionViewModelInputs{

  Sink get inputgetTransactions;



  void getTransactions();

}

abstract class TransactionViewModelOutputs{

  Stream<List<Transaction>> get outputgetTransactions;


}