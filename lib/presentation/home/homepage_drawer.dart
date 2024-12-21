import 'package:cached_network_image/cached_network_image.dart';
import 'package:easypark/app/di.dart';
import 'package:easypark/presentation/about/about_view.dart';
import 'package:easypark/presentation/current%20parkings/current_sessions_view.dart';
import 'package:easypark/presentation/payment/payment_screen_view.dart';
import 'package:easypark/presentation/profile/edit_profile_view.dart';
import 'package:easypark/presentation/promotions/promotions_screen.dart';
import 'package:easypark/presentation/vehicle/my%20vehicles/my_vehicles_view.dart';
import 'package:easypark/presentation/resources/color_manager.dart';
import 'package:easypark/presentation/resources/string_manager.dart';
import 'package:easypark/presentation/universal%20widgets/customtext.dart';
import 'package:easypark/presentation/vehicle/parking/parking_history_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
class DrawerWidget extends StatefulWidget {

  final Function(Widget destination) itemClicked;
  final VoidCallback onLogout;

  const DrawerWidget(this.itemClicked, this.onLogout, {Key? key}) : super(key: key);

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {

  late SharedPreferences  sharedPreferences;
  String name = "";
  String firstName = "";
  String lastName = "";
  String profile_pic = "";

  String email = "";

  @override
  void initState() {
    init();
    super.initState();
  }



  init()async{
    sharedPreferences = await SharedPreferences.getInstance();
    name = await  sharedPreferences.getString("name") ?? "";
    var listNames = name.split(" ");
    lastName = listNames[1];
    firstName = listNames[0];
    profile_pic = await  sharedPreferences.getString("profile_pic") ?? "";
    print(profile_pic);
    email = await  sharedPreferences.getString("email") ?? "";
    setState((){

    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Drawer(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(15), bottomRight: Radius.circular(15))),

        child: Column(
          // Important: Remove any padding from the ListView.
          children: [
            Hero(
              tag: 'header',
              child: Container(
                decoration: const BoxDecoration(
                    color: const Color.fromRGBO(253, 221, 220, 1),
                    borderRadius:
                    BorderRadius.only(topRight: Radius.circular(15))),
                height: 109,
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: CachedNetworkImageProvider(profile_pic,)
                              )
                          ),
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(name, 16, FontWeight.w700,
                              AppColors.blackColor),
                          SizedBox(
                            height: 3,
                          ),
                          CustomText(email, 12, FontWeight.w400,
                              AppColors.blackColor)
                        ],
                      ),
                      const SizedBox(
                        width: 26,
                      ),
                      InkWell(
                        onTap: () {
                          widget.itemClicked(EditProfileView(firstName: firstName, lastName: lastName, profileUrl: profile_pic, email: email));
                        },
                        child: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: AppColors.defaultRed),
                            child: const Icon(
                              Icons.edit,
                              size: 20,
                              color: AppColors.whiteColor,
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            ),
           Expanded(child: ListView(
             children: [
               const SizedBox(
                 height: 21,
               ),
               InkWell(
                 onTap: () {
                   widget.itemClicked(MyVehiclesView());
                 },
                 child: ListTile(
                   leading: Column(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                       SvgPicture.asset("assets/images/drawer/myvehicles.svg"),
                     ],
                   ),
                   title: CustomText(
                       AppStrings.myVehicles, 14, FontWeight.w500,
                       AppColors.blackColor),
                 ),
               ),
               Divider(),
               InkWell(
                 onTap: () {
                   widget.itemClicked(ParkingHistoryView());
                 },
                 child: ListTile(
                   leading: Column(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                       SvgPicture.asset("assets/images/drawer/parkinghistory.svg"),
                     ],
                   ),
                   title: CustomText(
                       AppStrings.parkingHistory, 14, FontWeight.w500,
                       AppColors.blackColor),
                 ),
               ),
               Divider(),
               InkWell(
                 onTap: () {
                   widget.itemClicked(PaymentScreenView());
                 },
                 child: ListTile(
                   leading: Column(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                       SvgPicture.asset("assets/images/drawer/payment.svg"),
                     ],
                   ),
                   title: Hero(
                     tag: 'second-anim',
                     child: CustomText(
                         AppStrings.payment, 14, FontWeight.w500,
                         AppColors.blackColor),
                   ),
                 ),
               ),
               Divider(),
               InkWell(
                 onTap: () {
                   widget.itemClicked(CurrentSessionsView());
                 },
                 child: ListTile(
                   leading: Column(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                       SvgPicture.asset("assets/images/drawer/myvehicles.svg"),
                     ],
                   ),
                   title: Hero(
                     tag: 'L',
                     child: CustomText(
                         AppStrings.currentParkingAndBills, 14, FontWeight.w500,
                         AppColors.blackColor),
                   ),
                 ),
               ),
               Divider(),
               InkWell(
                 onTap: () {
                   widget.itemClicked(PromotionsScreen());
                 },
                 child: ListTile(
                   leading: Column(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                       SvgPicture.asset("assets/images/drawer/promotions.svg"),
                     ],
                   ),
                   title: Hero(
                     tag: 'promotions',
                     child: CustomText(
                         AppStrings.promotions, 14, FontWeight.w500,
                         AppColors.blackColor),
                   ),
                 ),
               ),
               Divider(),
               SizedBox(height: size.height * 0.1,),

               Divider(),

               InkWell(
                 onTap: () {
                   widget.itemClicked(AboutView());
                 },
                 child: ListTile(
                   leading: Column(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                       SvgPicture.asset("assets/images/drawer/about.svg"),
                     ],
                   ),
                   title: CustomText(
                       "About & Support", 14, FontWeight.w500, AppColors.blackColor),
                 ),
               ),
               Divider(),
               InkWell(
                 onTap: widget.onLogout,
                 child: ListTile(
                   leading: Column(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                       SvgPicture.asset("assets/images/drawer/logout.svg"),
                     ],
                   ),
                   title: CustomText(
                       AppStrings.logout, 14, FontWeight.w500, AppColors.blackColor),
                 ),
               ),
               const SizedBox(
                 height: 10,
               ),
             ],
           ))
          ],
        ),

    );
  }
}

