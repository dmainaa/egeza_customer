import 'dart:async';

import 'package:easypark/app/app_utils.dart';
import 'package:easypark/app/di.dart';
import 'package:easypark/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';


class BaseUiShell extends StatefulWidget {
  final StreamController<bool> loadingStreamController;
  final StreamController<List<dynamic>> messageStreamController;
  final Widget contentWidget;
  const BaseUiShell(
      {Key? key,
      required this.loadingStreamController,
        required this.contentWidget,
      required this.messageStreamController})
      : super(key: key);

  @override
  State<BaseUiShell> createState() => _BaseUiShellState();
}

class _BaseUiShellState extends State<BaseUiShell> with SingleTickerProviderStateMixin{
  final AppUtils _appUtils = instance<AppUtils>();
  late AnimationController _controller;
  late Animation<double> _animation;
  String message = "";
  List<dynamic> results = [];

  StreamController<bool> showMessageController = StreamController.broadcast();

  _bind(){
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      widget.messageStreamController.stream.listen((results){
        if(!mounted) return;
        bool isError = results[0] as bool;
        _appUtils.showSnackbar(context, results[1], isError: isError);

      });
    });
  }

  _handleEventMessage() {
    widget.messageStreamController.stream.listen((message) async {
      if(!mounted)return;
      _appUtils.showSnackbar(context, message[1], isError: message[0]);
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _animation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));
    // _bind();
    _handleEventMessage();
  }


  @override
  void dispose() {
    super.dispose();
    showMessageController.close();
  }

  _startAnimation(){
    _controller.forward();
  }

  _resetAnimation(){
    _controller.reset();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        widget.contentWidget,
        StreamBuilder<bool>(stream: widget.loadingStreamController.stream, builder: (context, snapshot){
          bool isLoading = snapshot.data ?? false;

          if(isLoading){
            return Container(
              width: size.width,
              height: size.height,
              color: Colors.black.withOpacity(0.5),
              child: _appUtils.getLoadingContainer(),
            );
          }else{
            return Container();
          }
        }),
        StreamBuilder<bool>(stream: showMessageController.stream, builder: (context, snapshot){
          bool showMessage = snapshot.data ?? false;
          if(showMessage){
            return Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Builder(builder: (context) {
                    return _appUtils.getPopUpDialog(
                        isSuccess: results[0],
                        errorMessage: results[1],
                        onTryAgain: () {},
                        context: context);
                  }),
                );
          }else {
            return Container();
          }
        })

      ],
    );
  }
}
