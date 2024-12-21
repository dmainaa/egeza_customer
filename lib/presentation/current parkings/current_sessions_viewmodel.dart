import 'dart:async';

import 'package:easypark/domain/model/model.dart';
import 'package:easypark/domain/usecase/activesessions_usecase.dart';
import 'package:easypark/presentation/base/baseviewmodel.dart';
import 'package:easypark/presentation/common/state_renderer.dart';
import 'package:easypark/presentation/common/state_renderer_impl.dart';


class CurrentSessionsViewModel extends BaseViewModel implements CurrentSessionsViewModelInputs, CurrentSessionsViewModelOutputs{

  StreamController _sessionsStreamController = StreamController<List<Session>>.broadcast();

  StreamController _oneSessionStreamController = StreamController<Session>.broadcast();

  ActiveSessionsUsecase _usecase;


  CurrentSessionsViewModel(this._usecase);

  @override
  getSessions() async{
    loadingStreamController.add(true);
    (await _usecase.execute("input")).fold((l) {
      loadingStreamController.add(false);
      messagesStreamController.add([false, l.message]);
    }, (r)
    {
      loadingStreamController.add(false);
      if(r.length == 1){
        inputOneSession.add(r[0]);
      }else{
        inputSessions.add(r);
      }
    });
  }

  @override
  // TODO: implement inputSessions
  Sink get inputSessions => _sessionsStreamController.sink;

  @override
  // TODO: implement outputGetSessions
  Stream<List<Session>> get outputGetSessions => _sessionsStreamController.stream.map((event) => event);



  @override
  void start() {
    // TODO: implement start
  }

  @override
  void dispose() {
    // TODO: implement start
    _sessionsStreamController.close();
  }

  @override
  // TODO: implement inputOneSession
  Sink get inputOneSession => _oneSessionStreamController.sink;

  @override
  // TODO: implement outputOneSession
  Stream<Session> get outputOneSession => _oneSessionStreamController.stream.map((event) => event);

}


abstract class CurrentSessionsViewModelInputs{

  getSessions();

  Sink get inputSessions;

  Sink get inputOneSession;


}

abstract class CurrentSessionsViewModelOutputs{

  Stream<List<Session>> get outputGetSessions;

  Stream<Session> get outputOneSession;

}