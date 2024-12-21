import 'package:cached_network_image/cached_network_image.dart';
import 'package:easypark/domain/model/model.dart';
import 'package:easypark/domain/usecase/myvehicles_usecase.dart';
import 'package:easypark/main.dart';
import 'package:easypark/presentation/common/state_renderer.dart';
import 'package:easypark/presentation/common/state_renderer_impl.dart';
import 'package:easypark/presentation/resources/value_manager.dart';
import 'package:easypark/presentation/vehicle/my%20vehicles/my_vehicles_viewmodel.dart';

import 'package:easypark/presentation/resources/color_manager.dart';
import 'package:easypark/presentation/resources/string_manager.dart';
import 'package:easypark/presentation/universal%20widgets/customtext.dart';
import 'package:easypark/presentation/vehicle/vehicle%20details/vehicle_details_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../app/app_utils.dart';
import '../../base/base_ui_shell.dart';
import '../../common/empty_widget.dart';

class MyVehiclesView extends StatefulWidget {
  const MyVehiclesView({Key? key}) : super(key: key);

  @override
  State<MyVehiclesView> createState() => _MyVehiclesViewState();
}

class _MyVehiclesViewState extends State<MyVehiclesView> {

  MyVehiclesViewModel _viewModel = MyVehiclesViewModel(MyVehiclesUseCase());
  TextEditingController plateController = TextEditingController();


  final AppUtils _appUtils = GetIt.I<AppUtils>();
  @override
  void initState() {
    super.initState();
    _bind();
  }

  _bind(){
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _viewModel.isVehicleRegisteredSuccessfully.stream.listen((success) {
        _viewModel.messagesStreamController.add([true, AppStrings.vehicleAddedSuccessfully]);
        _viewModel.getMyVehicles();
      });

      plateController.addListener(() {_viewModel.setPlateNumber(plateController.text);});
      // _viewModel.inputState.add(LoadingState(StateRendererType.POPUP_LOADING_STATE, "Loading"));
    });
    _viewModel.getMyVehicles();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        key: scaffoldKey,
        elevation: 0,
        backgroundColor: AppColors.appBarColor,
        titleSpacing: 0,
        title: CustomText(
            AppStrings.myVehicles, 16, FontWeight.w700, AppColors.blackColor),
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop(true);
          },
          child: const Icon(
            Icons.arrow_back,
            color: AppColors.blackColor,
          ),
        ),
      ),
        body: BaseUiShell(
            loadingStreamController: _viewModel.loadingStreamController,
            contentWidget: getContentWidget(context),
            messageStreamController: _viewModel.messagesStreamController),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ElevatedButton(
          style: ElevatedButton.styleFrom(
              fixedSize: const Size(210, 56),
              backgroundColor: AppColors.defaultRed,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16))),
          onPressed: () {
            showModalBottomSheet(
              isScrollControlled: true,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(topRight: Radius.circular(32), topLeft: Radius.circular(32))),
              context: context,
              builder: (context) {
                return ModalBottomSheet(context);
              },
            );
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children:  [
             const Icon(Icons.add, color: Colors.white,),
             const SizedBox(
                width: 10,
              ),
              CustomText(
                  AppStrings.addVehicle, 14, FontWeight.w700, AppColors.whiteColor)
            ],
          )),
    );
  }

  Widget getContentWidget(BuildContext context){
    return Column(
        children: [
          Container(
            height: 35,
            decoration: const BoxDecoration(
                color: AppColors.appBarColor,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(28),
                    bottomRight: Radius.circular(28))),
          ),
          const SizedBox(height: 32,),
          Expanded(
            child: StreamBuilder<List<Vehicle>>(
                  stream: _viewModel.outputMyVehicles,
                  builder: (context, snapshot){
                    List<Vehicle> myVehicles = snapshot.data ?? [];
                    return myVehicles.isEmpty ? EmptyWidget(AppStrings.noVehicles, onRefresh: (){
                      _viewModel.getMyVehicles();
                    },) : RefreshIndicator(
                      onRefresh: ()async{
                        _viewModel.getMyVehicles();
                      },
                      child: ListView.separated(
                        separatorBuilder: (BuildContext context, int index){
                         return Divider(color: AppColors.dividerColor,);
                        },
                        shrinkWrap: true,
                        primary: false,
                        padding: EdgeInsets.zero,
                        itemCount: myVehicles.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Navigator.of(context).push(PageRouteBuilder(
                                pageBuilder: (
                                    BuildContext context,
                                    Animation<double> animation,
                                    Animation<double> secondaryAnimation,
                                    ) =>VehicleDetailsView(myVehicles[index], _viewModel),

                                transitionsBuilder: (
                                    BuildContext context,
                                    Animation<double> animation,
                                    Animation<double> secondaryAnimation,
                                    Widget child,
                                    ) =>
                                    SlideTransition(
                                      position: Tween<Offset>(
                                        begin: const Offset(1, 0),
                                        end: Offset.zero,
                                      ).animate(animation),
                                      child: child,
                                    ),
                              ));
                            },
                            child: ListTile(
                              leading: Container(
                                height: 54,
                                width: 54,

                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      fit: BoxFit.fill,
                                      image: CachedNetworkImageProvider(
                                          myVehicles[index].icon
                                      )
                                  ),

                                ),

                              ),
                              title: CustomText(myVehicles[index].title, 16,
                                  FontWeight.w700, AppColors.blackColor),
                              subtitle: RichText(
                                  text: TextSpan(children: [
                                    TextSpan(
                                        text: "${AppStrings.lastParked}: ",
                                        style: GoogleFonts.manrope(
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.blackColor)),
                                    TextSpan(
                                        text: myVehicles[index].lastParked,
                                        style: GoogleFonts.manrope(
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.w400,
                                            color: AppColors.blackColor))
                                  ])),
                              trailing: const Icon(
                                Icons.arrow_forward_ios,
                                color: AppColors.defaultRed,
                                size: 20,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },

                ),
          )


        ],

    );
  }

  Widget ModalBottomSheet(
      BuildContext context) {

    return Container(
      
          padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          margin: const EdgeInsets.symmetric(horizontal: 24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(height: 10,),
                SvgPicture.asset("assets/images/parkinginfo/modalbottom.svg"),
                Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: SvgPicture.asset("assets/images/drawer/addnewcar.svg")),
                CustomText(AppStrings.enterPlateNumber, 16,
                    FontWeight.w700, AppColors.blackColor),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: TextField(
                    controller: plateController,
                    decoration: InputDecoration(
                        hintText: AppStrings.enterPlateNumber
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: StreamBuilder<bool>(
                    stream: _viewModel.outputIsPlateNumberValid,
                    builder: (context, snapshot){
                      return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              fixedSize: const Size(210, 56),
                              backgroundColor:  (snapshot.data ?? false) ? AppColors.defaultRed : Colors.grey ,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16))),
                          onPressed: (snapshot.data ?? false) ? () {
                            Navigator.of(context).pop();
                            _viewModel.registerVehicle(plateController.text);
                          } : (){

                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children:  [
                              const Icon(Icons.add, color: Colors.white,),
                              const SizedBox(
                                width: 10,
                              ),
                              CustomText(AppStrings.addVehicle, 14, FontWeight.w700,
                                  AppColors.whiteColor)
                            ],
                          ));
                    },

                  ),
                ),
              ],

        ),));
      }




}
