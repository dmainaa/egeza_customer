import 'dart:async';


import 'package:easypark/app/app_utils.dart';
import 'package:easypark/app/di.dart';
import 'package:easypark/domain/model/model.dart';
import 'package:easypark/domain/usecase/homepage_usecase.dart';
import 'package:easypark/presentation/common/state_renderer.dart';
import 'package:easypark/presentation/common/state_renderer_impl.dart';
import 'package:easypark/presentation/current%20parkings/current_sessions_view.dart';
import 'package:easypark/presentation/home/home_page_viewmodel.dart';
import 'package:easypark/presentation/home/homepage_drawer.dart';
import 'package:easypark/presentation/home/logout_dialog.dart';
import 'package:easypark/presentation/phone/pnregistration_view.dart';
import 'package:easypark/presentation/resources/color_manager.dart';
import 'package:easypark/presentation/resources/string_manager.dart';
import 'package:easypark/presentation/universal%20widgets/customtext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../base/base_ui_shell.dart';


class HomePageView extends StatefulWidget {
  const HomePageView({Key? key}) : super(key: key);

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  Location? location = Location();
  late GoogleMapController _controller;

  AppUtils get appUtils => instance<AppUtils>();

  var _scaffoldKey = new GlobalKey<ScaffoldState>();

  HomePageViewModel? _viewModel;
  late SharedPreferences  preferences;

  LocationData? locationData;
  List<dynamic> results = [];
  LatLng? latLng;

  String userQR = "";
  Set<Marker> marker = {

  };


  @override
  void initState() {
    super.initState();

    _viewModel = HomePageViewModel(HomePageUseCase(), (parkingSpot){
      print("Clicked Parking Spot ${parkingSpot.name}");
      popUpBottomSheet(parkingSpot);
    });
    initializeLocation();
    _viewModel?.logoutController.stream.listen((success) {
      _viewModel?.loadingStreamController.add(false);
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        if(success){
          preferences.clear();
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => PNRegistration(),
            ),
                (route) => false,
          );
        }else{
          _viewModel?.messagesStreamController.add([false, AppStrings.somethingWentWrong]);
        }
      });});

    _viewModel?.getMarkers();

  }

  void initializeLocation()async{
      preferences = await SharedPreferences.getInstance();
     SharedPreferences.getInstance().then((preferences){
       latLng = LatLng(preferences.getDouble("latitude") ?? -1.2849483, preferences.getDouble("longitude") ?? 36.8228721);
       SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
         var newPosition = CameraPosition(
             target: LatLng(latLng?.latitude ?? -1.2849483, latLng?.longitude ?? 36.8228721),
             zoom: 16);

         CameraUpdate update =CameraUpdate.newCameraPosition(newPosition);
         CameraUpdate zoom = CameraUpdate.zoomTo(16);
         _controller.moveCamera(update);
       });
     });
     setState(() {

     });

  }

  void popUpBottomSheet(ParkingSpot spot){
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(28),
              topRight: Radius.circular(28))),
      context: context,
      builder: (context) {
        return modalLocation(context, spot);
      },
    );
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      key: _scaffoldKey,
      drawer: DrawerWidget(onItemClicked, showLogoutDialog),
        body: BaseUiShell(
            loadingStreamController: _viewModel!.loadingStreamController,
            contentWidget: getContentView(context),
            messageStreamController: _viewModel!.messagesStreamController));

  }

  void cloaseDrawer(){
    _scaffoldKey.currentState?.closeDrawer();
  }

  void showLogoutDialog(){
    cloaseDrawer();
    Dialog dialog = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      elevation: 1.5,
      child: LogOutDialog((){
        Navigator.of(context).pop(true);
        _viewModel?.logout();
      }, (){
      Navigator.of(context).pop(true);

      }),

    );

    showDialog(context: context, builder: (BuildContext context) => dialog);
  }

  Widget getContentView(BuildContext context){
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        StreamBuilder<Set<Marker>>(
          stream: _viewModel?.outputMarkersStream,
          builder: (context, snapshot){
            print(snapshot.toString());
            return GoogleMap(
                onMapCreated: (controller){
                  setState(() {
                    _controller = controller;
                  });
                },
                myLocationEnabled: true,
                markers: snapshot.data ?? {},
                initialCameraPosition: CameraPosition(
                    bearing: 2,
                    zoom: 10,
                    target: LatLng(latLng?.latitude ??  -1.2849483, latLng?.longitude ?? 36.8228721))
            );
          },

        ),
        Positioned(
            top: 60,
            left: 24,
            child: GestureDetector(
              onTap: () {
                _scaffoldKey.currentState!.openDrawer();
              },
              child: Container(
                  height: 44,
                  width: 44,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.white),
                  child: const Icon(Icons.list)),
            )),
        Positioned(
            top: 60,
            right: 24,
            child: GestureDetector(
              onTap: () {
                // route(context, Notifications());
              },
              child: Stack(
                children: [
                  Container(
                      height: 44,
                      width: 44,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.white),
                      child: const Icon(Icons.notifications_outlined)),
                  const Positioned(
                    right: 0,
                    child: Icon(
                      Icons.circle,
                      size: 13,
                      color: AppColors.defaultRed,
                    ),
                  ),
                ],
              ),
            )),
        Positioned(
            bottom: 0,
            child: GestureDetector(
                onVerticalDragStart: (details) => showModalSheet(),
                child: modalWidget())),

        StreamBuilder<List<dynamic>>(
          stream: _viewModel?.outputResults,

          builder: (context, snapshot){
            print("I have reached here");
            userQR = snapshot.data?[1] ?? "";
            bool hasActive = snapshot.data?[0] ?? false;
            return hasActive ?  Positioned(
                bottom: size.height * 0.2,
                left: size.width * 0.3,


                child: InkWell(
                    onTap:() {
                      Navigator.of(context).push(PageRouteBuilder(
                        pageBuilder: (
                            BuildContext context,
                            Animation<double> animation,
                            Animation<double> secondaryAnimation,
                            ) => CurrentSessionsView(),

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
                    child: Image.asset("assets/images/parkinginfo/checkout_icon.png"))) : Container();
          },

        ),

      ],
    );
  }

  modalLocation(BuildContext context, ParkingSpot spot) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.8,
      builder: (context, scrollController) => Column(
        children: [
          Container(
            height: 123,
            decoration: const BoxDecoration(
                color: AppColors.blackColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(28),
                    topRight: Radius.circular(28))),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 16,
                ),
                SvgPicture.asset(
                  "assets/images/parkinginfo/modalbottom.svg",
                  color: AppColors.whiteColor,
                ),
                const SizedBox(
                  height: 21,
                ),
                ListTile(
                  leading: SvgPicture.asset("assets/images/parking.svg"),
                  title: CustomText(spot.name, 20, FontWeight.w800,
                      AppColors.whiteColor),
                  subtitle: CustomText(
                      spot.distance, 20, FontWeight.w800, AppColors.whiteColor),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          Container(
            alignment: Alignment.center,
            height: 100,
            width: 335,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Color.fromRGBO(234, 234, 234, 1)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText("Available Spaces", 16, FontWeight.w600,
                        AppColors.blackColor),
                    const SizedBox(
                      height: 8,
                    ),
                    Container(
                      alignment: Alignment.center,
                      height: 38,
                      width: 128,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Color.fromRGBO(230, 237, 252, 1)),
                      child: CustomText("${spot.availableSpaces.toString()} Spaces", 16, FontWeight.w600,
                          AppColors.blackColor),
                    ),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(AppStrings.parkingRate, 16, FontWeight.w600,
                        AppColors.blackColor),
                    const SizedBox(
                      height: 8,
                    ),
                    Container(
                      alignment: Alignment.center,
                      height: 38,
                      width: 128,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Color.fromRGBO(255, 233, 233, 1)),
                      child: CustomText("KES ${spot.ratePerMinute}/min", 16, FontWeight.w600,
                          AppColors.blackColor),
                    )
                  ],
                )
              ],
            ),
          ),
          const SizedBox(
            height: 28,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 24),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    fixedSize: Size(MediaQuery.of(context).size.width, 56),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    backgroundColor: AppColors.defaultRed),
                onPressed: () {
                  String directionsUrl = "https://www.google.com/maps/dir/?api=1&origin=${latLng?.latitude.toString()},%20${latLng?.longitude.toString()}&destination=${spot.latitude.toString()},%20${spot.longitude.toString()}";
                  appUtils.launchURL(directionsUrl);
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.map,
                      color: AppColors.whiteColor,
                    ),
                    CustomText(AppStrings.showDirections, 14, FontWeight.w700,
                        AppColors.whiteColor)
                  ],
                )),
          )
        ],
      ),
    );
  }


  @override
  void dispose() {
    super.dispose();

  }

  void onItemClicked(Widget destination){
    print("I have been called");
    _scaffoldKey.currentState?.closeDrawer();
    Navigator.of(context).push(PageRouteBuilder(
      pageBuilder: (
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
          ) => destination,

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
  }

  void showModalSheet() {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16), topRight: Radius.circular(16))),
      context: context,
      builder: (context) {
        return Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SvgPicture.asset("assets/images/parkinginfo/modalbottom.svg"),
              Column(
                children: [
                  CustomText("New to our parkings?", 14, FontWeight.w400,
                      AppColors.blackColor),
                  CustomText("Show this code to parking attendent", 16,
                      FontWeight.w600, AppColors.blackColor),
                ],
              ),
              Container(
                width: 200,
                  height: 200,
                  child: QrImageView(data: userQR)),
              Container(
                alignment: Alignment.center,
                height: 52,
                width: 206,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Color.fromRGBO(255, 235, 233, 1)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children:  [
                    Icon(Icons.car_rental),
                     SizedBox(
                      width: 20,
                    ),
                    CustomText(
                        userQR.toString(), 20, FontWeight.w700, AppColors.blackColor)
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}



class modalWidget extends StatelessWidget {
  const modalWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(32), topRight: Radius.circular(32))),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 16,
            ),
            SvgPicture.asset("assets/images/parkinginfo/modalbottom.svg"),
            const SizedBox(height: 23),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset("assets/images/parkinginfo/qr_scanner.svg"),
                const SizedBox(
                  width: 16,
                ),
                Hero(
                  tag: "hero",
                  child: Column(
                    children:  [
                      CustomText(AppStrings.newToOurParkings, 14, FontWeight.w400,
                          AppColors.textGrey),
                      SizedBox(
                        height: 2,
                      ),
                      CustomText(AppStrings.pullUpCode, 16, FontWeight.w600,
                          AppColors.blackColor),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            )
            // const SizedBox(height: 30),
            // SizedBox(height: 246, width: 246, child: QrImage(data: "1234567890")),
            // const SizedBox(
            //   height: 12,
            // ),
          ],
        ),
      ),
    );
  }
}



