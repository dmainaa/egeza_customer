import 'package:easypark/domain/model/model.dart';
import 'package:easypark/domain/usecase/activesessions_usecase.dart';
import 'package:easypark/presentation/base/base_ui_shell.dart';
import 'package:easypark/presentation/common/state_renderer.dart';
import 'package:easypark/presentation/common/state_renderer_impl.dart';
import 'package:easypark/presentation/current%20parkings/current_sessions_viewmodel.dart';
import 'package:easypark/presentation/current%20parkings/list_local.dart';
import 'package:easypark/presentation/resources/color_manager.dart';
import 'package:easypark/presentation/resources/string_manager.dart';
import 'package:easypark/presentation/universal%20widgets/customtext.dart';
import 'package:easypark/presentation/vehicle/parking/parking_info/parking_info_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class CurrentSessionsView extends StatefulWidget {
  const CurrentSessionsView({Key? key}) : super(key: key);

  @override
  State<CurrentSessionsView> createState() => _CurrentSessionsViewState();
}

class _CurrentSessionsViewState extends State<CurrentSessionsView> {

  CurrentSessionsViewModel _viewModel = CurrentSessionsViewModel(ActiveSessionsUsecase());


  @override
  void initState() {
    super.initState();
    _bind();
  }

  _bind(){
    SchedulerBinding.instance.addPostFrameCallback((timestamp){
      _viewModel.outputOneSession.listen((session) {
        navigateToParkingInfo(session);
      });
      // Add Your Code here.

    });
    _viewModel.getSessions();

  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.appBarColor,
        titleSpacing: 0,
        leading: GestureDetector(
            onTap: (){

              Navigator.of(context).pop(true);

            },
            child: const Icon(
              Icons.arrow_back,
              color: AppColors.blackColor,
            )),

      ),
        body: BaseUiShell(
            loadingStreamController: _viewModel.loadingStreamController,
            contentWidget: getContentView(context),
            messageStreamController: _viewModel.messagesStreamController));
  }

  Widget getContentView(BuildContext context){
    return Column(
        children: [
          Container(
            height: 100,
            width: double.infinity,
            decoration: const BoxDecoration(
                color: AppColors.appBarColor,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(28),
                    bottomRight: Radius.circular(28))),
            child:  Center(
              child: Hero(
                tag: 'firstr',
                child: CustomText(AppStrings.currentParkingAndBills, 20,
                    FontWeight.w700, AppColors.blackColor),
              ),
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          Expanded(
              child: StreamBuilder<List<Session>>(
                stream: _viewModel.outputGetSessions,
                builder: (context, snapshot){
                  List<Session> allSessions = snapshot.data ?? [];
                  return allSessions.isEmpty ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              AppStrings.noSessionsAtTheMoment, style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontSize: 16.0,
                                color: AppColors.textGrey
                            ), textAlign: TextAlign.center,),
                          ),
                        ),
                      ],
                    ),
                  ): RefreshIndicator(
                    onRefresh: ()async{
                      Future.delayed(Duration(seconds: 1), (){
                        _viewModel.getSessions();
                      });
                    },
                    child: ListView.builder(
                      itemCount: allSessions.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    transitionDuration: const Duration(milliseconds: 500),
                                    pageBuilder:
                                        (context, animation, secondaryAnimation) {
                                      return ParkingInfo(allSessions[index]);
                                    }));

                            },
                            child: ListLocal(

                                allSessions[index].icon,
                                allSessions[index].start,
                                allSessions[index].title,
                                allSessions[index].gross


                        ));


                      },
                    ),
                  );
                },

              ))
        ],


    );
  }

  @override
  void dispose() {
    super.dispose();
    _viewModel.dispose();
  }

  void navigateToParkingInfo(Session session){
    Navigator.push(
        context,
        PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 500),
            pageBuilder:
                (context, animation, secondaryAnimation) {
              return ParkingInfo(session);
            }));
  }
}
