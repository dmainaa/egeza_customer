

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easypark/domain/model/model.dart';
import 'package:easypark/presentation/check_out/checkout_view.dart';
import 'package:easypark/presentation/check_out/checkout_viewmodel.dart';
import 'package:easypark/presentation/common/state_renderer_impl.dart';
import 'package:easypark/presentation/resources/color_manager.dart';
import 'package:easypark/presentation/resources/string_manager.dart';
import 'package:easypark/presentation/universal%20widgets/customtext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';

import '../../../base/base_ui_shell.dart';

class ParkingInfo extends StatefulWidget {
  ParkingInfo(this.session, {Key? key}) : super(key: key);
  Session session;


  @override
  State<ParkingInfo> createState() => _ParkingInfoState();
}

class _ParkingInfoState extends State<ParkingInfo> {

  CheckOutViewModel _viewModel = CheckOutViewModel();

  String fj = "0.0";


  @override
  void initState() {
    super.initState();
    _bind();
  }

  _bind(){
    _viewModel.checkoutStreamController.stream.listen(( billId) {
      print("Fetched bill id: $billId");
       SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        if(billId.toString().isNotEmpty){
          Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (context){
            return CheckOutView(billId);
          }));
        }
      });
    });
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        elevation: 0,
        backgroundColor: AppColors.appBarColor,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.blackColor,
          ),
        ),
        title: Hero(
            tag: 'first',
            child:
            CustomText(widget.session.title, 16, FontWeight.w700, AppColors.blackColor)),
      ),
        body: BaseUiShell(
            loadingStreamController: _viewModel.loadingStreamController,
            contentWidget: getContentWidget(context),
            messageStreamController: _viewModel.messagesStreamController));
  }

  Widget getContentWidget(BuildContext context){
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: [
          Stack(
            alignment: Alignment.topCenter,
            children: [
              const SizedBox(
                height: 150,
              ),
              Container(
                height: 100,
                width: double.infinity,
                decoration: const BoxDecoration(
                    color: AppColors.appBarColor,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(28),
                        bottomRight: Radius.circular(28))),
                child: const Text(""),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.fill,
                          image: CachedNetworkImageProvider(
                              widget.session.icon
                          )
                      ),
                      color: const Color.fromRGBO(216, 216, 255, 1),
                      borderRadius: BorderRadius.circular(100)),

                ),
              )
            ],
          ),
          const SizedBox(
            height: 24,
          ),
          CustomText(
              AppStrings.accruedBill, 14, FontWeight.w500, AppColors.blackColor),
          const SizedBox(
            height: 12,
          ),
          Container(
            height: 61,
            width: size.width * 0.9,
            decoration: BoxDecoration(
                color: const Color.fromRGBO(235, 235, 235, 1),
                borderRadius: BorderRadius.circular(16)),
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(5.0),
                child: CustomText(
                    "KES ${widget.session.gross}", 24, FontWeight.w700, AppColors.blackColor),
              ),
            ),
          ),
          const SizedBox(
            height: 35,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 34),
            child: ListView(
              shrinkWrap: true,
              primary: false,
              children: [
                ListTile(
                  leading:
                  SvgPicture.asset("assets/images/parkinginfo/start.svg"),
                  title:  CustomText(
                      AppStrings.start, 16, FontWeight.w700, AppColors.blackColor),
                  trailing:  CustomText(widget.session.start, 16,
                      FontWeight.w500, AppColors.blackColor),
                ),
                ListTile(
                  leading: SvgPicture.asset(
                      "assets/images/parkinginfo/timespent.svg"),
                  title:  CustomText(
                      AppStrings.timeSpent, 16, FontWeight.w700, AppColors.blackColor),
                  trailing:  CustomText(
                      widget.session.minutes_spent.toString() + " minutes", 16, FontWeight.w500, AppColors.blackColor),
                ),
                ListTile(
                  leading:
                  SvgPicture.asset("assets/images/parkinginfo/rate.svg"),
                  title:  CustomText(
                      AppStrings.rate, 16, FontWeight.w700, AppColors.blackColor),
                  trailing: CustomText("KES ${widget.session.rate_per_minute}", 16, FontWeight.w500,
                      AppColors.blackColor),
                ),
                ListTile(
                  leading:
                  SvgPicture.asset("assets/images/parkinginfo/basepay.svg"),
                  title:  CustomText(
                      AppStrings.basePay, 16, FontWeight.w700, AppColors.blackColor),
                  trailing: CustomText("KES ${widget.session.base_pay}", 16, FontWeight.w500,
                      AppColors.blackColor),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 25,
          ),

          Container(
              alignment: Alignment.center,
              height: 40,
              width: 310,
              decoration: BoxDecoration(
                  color:  const Color.fromRGBO(255, 236, 219, 1),
                  borderRadius: BorderRadius.circular(100)),
              child: Row(mainAxisSize: MainAxisSize.min, children:  [
                const Icon(
                  Icons.warning_amber_outlined,
                  color: Color.fromRGBO(245, 118, 0, 1),
                ),
                const SizedBox(width: 10),
                Builder(builder: (context){
                  if(widget.session.gross == "0.0"){
                    return CustomText("If you exit within ${widget.session.exitMinutes.toString()} minutes, you will not have to pay anything", 11,
                        FontWeight.w500, AppColors.blackColor);
                  }else if(widget.session.billStatus == "paid"){
                    return CustomText("Kindly exit within ${widget.session.exitMinutes.toString()} minutes, to avoid extra charges.", 11,
                        FontWeight.w500, AppColors.blackColor);
                  }else{
                   return CustomText(AppStrings.ifyouexitnow, 11,
                        FontWeight.w500, AppColors.blackColor);
                  }
                }),

              ])),
          const SizedBox(height: 27),
          Builder(builder: (context){
            if(widget.session.gross == "0.0"){
              return Container();
            }else if(widget.session.billStatus == "paid"){
              return Container();
            }else{
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        minimumSize: const Size(double.infinity, 56),
                        backgroundColor: AppColors.defaultRed),
                    onPressed: () {
                      _viewModel.checkOut(widget.session.id.toString());
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.payment, color: AppColors.whiteColor),
                        const SizedBox(
                          width: 13.5,
                        ),
                        CustomText(
                            "Checkout", 14, FontWeight.w700, AppColors.whiteColor)
                      ],
                    )),
              );
            }
          }),

          const SizedBox(height: 10,)
        ],
      ),
    );
  }
}



