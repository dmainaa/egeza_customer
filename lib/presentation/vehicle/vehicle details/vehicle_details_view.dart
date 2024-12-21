

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easypark/domain/model/model.dart';
import 'package:easypark/domain/usecase/parkinghistory_usecase.dart';
import 'package:easypark/presentation/base/base_ui_shell.dart';
import 'package:easypark/presentation/common/state_renderer_impl.dart';
import 'package:easypark/presentation/resources/color_manager.dart';
import 'package:easypark/presentation/resources/string_manager.dart';
import 'package:easypark/presentation/universal%20widgets/customtext.dart';
import 'package:easypark/presentation/vehicle/my%20vehicles/my_vehicles_view.dart';
import 'package:easypark/presentation/vehicle/my%20vehicles/my_vehicles_viewmodel.dart';
import 'package:easypark/presentation/vehicle/vehicle%20details/vehicle_details_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';

import '../../../app/app_utils.dart';
enum Menu { itemOne, itemTwo, itemThree, itemFour }
class VehicleDetailsView extends StatefulWidget {

  final Vehicle vehicle;
  final MyVehiclesViewModel viewModel;
  const VehicleDetailsView(this.vehicle, this.viewModel,  {Key? key}) : super(key: key);

  @override
  State<VehicleDetailsView> createState() => _VehicleDetailsViewState();
}

class _VehicleDetailsViewState extends State<VehicleDetailsView> {



  VehicleDetailsViewModel _viewModel = VehicleDetailsViewModel(ParkingHistoryUseCase());
  final AppUtils _appUtils = GetIt.I<AppUtils>();


  @override
  void initState() {
    super.initState();
    _viewModel.getParkingHistory(widget.vehicle.id.toString(), false);

    _viewModel.deleteVehicleStreamController.stream.listen((isSuccess) {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        goBack();
      });
    });

    _viewModel.responseStreamController.stream.listen((isSuccess) {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        Navigator.pop(context);
        showDialog(context: context, builder: (context){
          return _appUtils.getPopUpDialog(isSuccess: isSuccess, context: context, errorMessage: _viewModel.responseMessage, onTryAgain: (){
            Navigator.of(context).pop(true);
            _viewModel.getParkingHistory(widget.vehicle.id.toString(), false);
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (value){
        goBack();
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: AppColors.appBarColor,
          leading: GestureDetector(
              onTap: () {
                goBack();
              },
              child: const Icon(
                Icons.arrow_back,
                color: AppColors.blackColor,
              )),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                  widget.vehicle.title, 14, FontWeight.w700, AppColors.blackColor),
              CustomText("${AppStrings.lastParked} ${widget.vehicle.lastParked}", 12, FontWeight.w400,
                  AppColors.blackColor),
            ],
          ),
          titleSpacing: 5,
          actions: [
            PopupMenuButton(
              icon: const Icon(
                Icons.more_vert,
                color: AppColors.defaultRed,
              ),
              onSelected: (_) {
                showModalBottomSheet(
                  constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.30),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32))),
                  context: context,
                  builder: (context) {
                    return bottomSheet();
                  },
                );
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<Menu>>[
                PopupMenuItem<Menu>(
                  value: Menu.itemOne,
                  child: GestureDetector(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset("assets/images/drawer/delete.svg"),
                        const SizedBox(
                          width: 15,
                        ),
                         CustomText(
                             AppStrings.delete, 16, FontWeight.w400, AppColors.defaultRed
                         )
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
          body: BaseUiShell(
              loadingStreamController: _viewModel.loadingStreamController,
              contentWidget: getContentView(context),
              messageStreamController: _viewModel.messagesStreamController)),
    );
  }

  Future<bool> goBack() async{
    widget.viewModel.getMyVehicles();

    Navigator.of(context).pop();

    return true;
  }

  Widget getContentView(BuildContext context){
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 35,
          decoration: const BoxDecoration(
              color: AppColors.appBarColor,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(28),
                  bottomRight: Radius.circular(28))),
          child:
          CustomText("", 14, FontWeight.w400, AppColors.blackColor),
        ),
        const SizedBox(
          height: 32,
        ),
        Expanded(
          child: StreamBuilder<List<ParkingHistory>>(
                stream: _viewModel.outputParkingHistory,
                builder: (context, snapshot){
                  List<ParkingHistory> parkingHistory = snapshot.data ?? [];
                  return parkingHistory.isNotEmpty ?  ListView.builder(
                      itemCount: parkingHistory.length,
                      itemBuilder: (context, index){
                        return ListTile(
                          leading: Container(
                            alignment: Alignment.center,
                            height: 54,
                            width: 54,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: CachedNetworkImageProvider(widget.vehicle.icon)
                              ),
                            ),

                          ),
                          title:  CustomText(parkingHistory[index].title, 16, FontWeight.w700,
                              AppColors.blackColor),
                          subtitle:  CustomText("Start ${parkingHistory[index].startTime}", 14,
                              FontWeight.w400, AppColors.blackColor),
                          trailing:  CustomText(
                              parkingHistory[index].bill, 16, FontWeight.w700, AppColors.blackColor),
                        );
                      },

                  ) : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              AppStrings.noParkingHistory, style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontSize: 16.0,
                                color: AppColors.textGrey
                            ), textAlign: TextAlign.center,),
                          ),
                        ),
                      ],
                    ),
                  );
                },

              ),
        ),
      ],
    );
  }

  Widget bottomSheet() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SvgPicture.asset("assets/images/parkinginfo/modalbottom.svg"),
          CustomText("Do you want to delete vehicle details?", 16,
              FontWeight.w700, AppColors.blackColor),
          ListTile(
            leading: Container(
              height: 54,
              width: 54,
              decoration: BoxDecoration(
                  color: const Color.fromRGBO(216, 216, 255, 1),
                  borderRadius: BorderRadius.circular(100)),
              child: const Icon(Icons.car_repair_rounded),
            ),
            title: CustomText(
                widget.vehicle.title, 16, FontWeight.w700, AppColors.blackColor),
            trailing: Column(
              children: [
                 CustomText(
                    AppStrings.lastParked, 14, FontWeight.w600, AppColors.blackColor),
                 SizedBox(
                  height: 5,
                ),
                CustomText(widget.vehicle.lastParked, 10, FontWeight.w400,
                    AppColors.blackColor)
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () {
                  _viewModel.deleteVehicle(widget.vehicle.id.toString());
                 Navigator.of(context).pop();
                },
                child: Container(
                  height: 56,
                  width: MediaQuery.of(context).size.width * 0.40,
                  decoration: BoxDecoration(
                      color: AppColors.defaultRed,
                      borderRadius: BorderRadius.circular(16)),
                  child:  Center(
                    child: CustomText(
                        AppStrings.yes, 14, FontWeight.w700, AppColors.whiteColor),
                  ),
                ),
              ),
              Container(
                height: 56,
                width: MediaQuery.of(context).size.width * 0.40,
                decoration: BoxDecoration(
                    border: Border.all(color: AppColors.defaultRed),
                    borderRadius: BorderRadius.circular(16)),
                child:  Center(
                  child: CustomText(
                      AppStrings.no, 14, FontWeight.w700, AppColors.defaultRed),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
