

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easypark/app/app_utils.dart';
import 'package:easypark/domain/model/model.dart';
import 'package:easypark/domain/usecase/myvehicles_usecase.dart';
import 'package:easypark/domain/usecase/parkinghistory_usecase.dart';
import 'package:easypark/presentation/common/state_renderer_impl.dart';
import 'package:easypark/presentation/resources/color_manager.dart';
import 'package:easypark/presentation/resources/string_manager.dart';
import 'package:easypark/presentation/universal%20widgets/customtext.dart';
import 'package:easypark/presentation/vehicle/my%20vehicles/my_vehicles_viewmodel.dart';
import 'package:easypark/presentation/vehicle/vehicle%20details/vehicle_details_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../app/di.dart';
import '../../base/base_ui_shell.dart';
import '../../common/empty_widget.dart';

class ParkingHistoryView extends StatefulWidget {
  const ParkingHistoryView({Key? key}) : super(key: key);

  @override
  State<ParkingHistoryView> createState() => _ParkingHistoryViewState();
}

class _ParkingHistoryViewState extends State<ParkingHistoryView> {

  VehicleDetailsViewModel _viewModel = VehicleDetailsViewModel(ParkingHistoryUseCase());
  AppUtils get _appUtils => instance<AppUtils>();
  _bind(){
    super.initState();
    _viewModel.getParkingHistory("", true);

  }


  @override
  void initState() {
    super.initState();
    _bind();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarWidget(context),
        body: BaseUiShell(
            loadingStreamController: _viewModel.loadingStreamController,
            contentWidget: getContentView(context),
            messageStreamController: _viewModel.messagesStreamController));
  }



  dynamic modalBottom(ParkingHistory history) {
    String mapsUrl = "https://maps.googleapis.com/maps/api/staticmap?center=${history.latitude.toString()},${history.longitude.toString()}&zoom=8&size=400x400&key=AIzaSyBCSqnMTOVAZwh-gpnz1wj3fe5-iOIpIwU";
    print(mapsUrl);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: DraggableScrollableSheet(
        initialChildSize: 0.70,
        expand: false,
        builder: (context, scrollController) => Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SvgPicture.asset("assets/images/parkinginfo/modalbottom.svg"),
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
              ),
              child: Image.network(
                // pass the relevant longitudes here
                mapsUrl,
                // "https://maps.googleapis.com/maps/api/staticmap?center=${history.latitude.toString()},${history.longitude.toString()}&zoom=8&size=100x100&key=AIzaSyBCSqnMTOVAZwh-gpnz1wj3fe5-iOIpIwU",
                fit: BoxFit.cover,
              ),
            ),
            ListTile(
              leading: SvgPicture.asset("assets/images/parkinginfo/start.svg"),
              title:  CustomText(
                  AppStrings.entry, 16, FontWeight.w700, AppColors.blackColor),
              trailing:  CustomText(history.startTime, 16,
                  FontWeight.w500, AppColors.blackColor),
            ),
            ListTile(
              leading:
              SvgPicture.asset("assets/images/parkinginfo/timespent.svg"),
              title:  CustomText(
                  AppStrings.exit, 16, FontWeight.w700, AppColors.blackColor),
              trailing:  CustomText(history.endTime, 16,
                  FontWeight.w500, AppColors.blackColor),
            ),
            ListTile(
              leading: SvgPicture.asset("assets/images/status.svg"),
              title:  CustomText(
                  AppStrings.bill, 16, FontWeight.w700, AppColors.blackColor),
              trailing:  CustomText(
                  history.bill, 16, FontWeight.w500, AppColors.blackColor),
            ),
            ListTile(
              leading: SvgPicture.asset("assets/images/status.svg"),
              title:  CustomText(
                  AppStrings.status, 16, FontWeight.w700, AppColors.blackColor),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children:  [
                  const Icon(
                    Icons.verified,
                    color: Colors.green,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  CustomText(AppStrings.verify, 16, FontWeight.w500, Colors.green)
                ],
              ),
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    fixedSize: Size(MediaQuery.of(context).size.width, 56),
                    backgroundColor: AppColors.defaultRed,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16))),
                onPressed: () {
                  Navigator.of(context).pop();
                  _appUtils.launchURL(history.receipt_url);
                },
                child:  CustomText(
                    AppStrings.download, 14, FontWeight.w700, AppColors.whiteColor)),
          ],
        ),
      ),
    );
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
                return parkingHistory.isNotEmpty ? ListView.separated(
                  separatorBuilder: (BuildContext context, int index){
                    return Divider(color: AppColors.dividerColor,);
                  },
                  itemCount: parkingHistory.length,
                  itemBuilder: (context, index){
                    return GestureDetector(
                      onTap: (){
                        showModalBottomSheet(
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(32), topRight: Radius.circular(32))),
                          context: context,
                          builder: (context) {
                            return modalBottom(parkingHistory[index]);
                          },
                        );
                      },
                      child: ListTile(
                        leading: Container(
                          alignment: Alignment.center,
                          height: 54,
                          width: 54,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            image: DecorationImage(
                                fit: BoxFit.fill,
                                image: CachedNetworkImageProvider(parkingHistory[index].icon)
                            ),
                          ),

                        ),
                        title:  CustomText(parkingHistory[index].title, 14, FontWeight.w700,
                            AppColors.textGrey),
                        subtitle:  CustomText("${parkingHistory[index].startTime}", 12,
                            FontWeight.w400, AppColors.blackColor),
                        trailing:  CustomText(
                            parkingHistory[index].bill, 14, FontWeight.w700, AppColors.blackColor),
                      ),
                    );
                  },
                ) : EmptyWidget(AppStrings.noParkingHistory);
              },

            ))
      ],
    );
  }

  AppBar appBarWidget(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: AppColors.appBarColor,
      leading: GestureDetector(
          onTap:goBack,
          child: const Icon(
            Icons.arrow_back,
            color: AppColors.blackColor,
          )),
      title:  CustomText(
          AppStrings.parkingHistory, 12, FontWeight.w700, AppColors.blackColor,centerJustification: true, ),
    );
  }

  Future<bool> goBack() async{


    Navigator.of(context).pop();

    return true;
  }
}
