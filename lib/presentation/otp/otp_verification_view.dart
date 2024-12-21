
import 'package:easypark/app/di.dart';
import 'package:easypark/domain/usecase/verify_otp.dart';
import 'package:easypark/presentation/common/state_renderer_impl.dart';
import 'package:easypark/presentation/finishup/finishup_view.dart';
import 'package:easypark/presentation/home/home_page_view.dart';
import 'package:easypark/presentation/otp/otp_verification_view.dart';
import 'package:easypark/presentation/otp/otp_viewmodel.dart';
import 'package:easypark/presentation/phone/pnregistration_view.dart';
import 'package:easypark/presentation/resources/color_manager.dart';
import 'package:easypark/presentation/resources/string_manager.dart';
import 'package:easypark/presentation/universal%20widgets/customtext.dart';
import 'package:easypark/presentation/universal%20widgets/largebutton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../app/app_utils.dart';
import '../base/base_ui_shell.dart';

class OTPVerification extends StatefulWidget {
   String enteredPhone = "";

  OTPVerification(this.enteredPhone, {Key? key} ) : super(key: key);

  @override
  State<OTPVerification> createState() => _OTPVerificationState();
}

class _OTPVerificationState extends State<OTPVerification> {
 late SharedPreferences  preferences;
  final OTPViewModel _viewModel =  OTPViewModel(VerifyOTPUseCase());
 final AppUtils _appUtils = GetIt.I<AppUtils>();

  TextEditingController controller =  TextEditingController();

  _bind() async{
    preferences = await SharedPreferences.getInstance();

    _viewModel.otpVerifiedStreamController.stream.listen((userExists) {
      if(userExists){
        preferences.setBool("isLoggedin", true);
      }
      SchedulerBinding?.instance.addPostFrameCallback((timeStamp) {

        Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder:
                  (context, animation, secondaryAnimation) {
                return userExists ? HomePageView() : LetFinUp();
              },
              transitionDuration: const Duration(milliseconds: 400),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                const begin = Offset(1.0, 0.0);
                const end = Offset.zero;
                final tween = Tween(begin: begin, end: end);
                final offsetAnimation = animation.drive(tween);
                return SlideTransition(
                    position: offsetAnimation, child: child);
              },
            ));
      });
    });
  }


  @override
  void initState() {

    _bind();
  }

  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      resizeToAvoidBottomInset: true,
        body: BaseUiShell(
            loadingStreamController: _viewModel.loadingStreamController,
            contentWidget: getContentView(context),
            messageStreamController: _viewModel.messagesStreamController));
  }

  Widget getContentView(BuildContext context){
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Container(
        width: size.width,
        height: size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [

            SvgPicture.asset("assets/images/otp_verification.svg"),

            CustomText(AppStrings.enterOtp, 14, FontWeight.w400,
                AppColors.blackColor),

            otpReflection(),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 32),
              child: PinCodeTextField(
                keyboardType: TextInputType.number,
                textStyle: GoogleFonts.manrope(fontSize: 16),
                appContext: context,
                length: 6,
                pinTheme: PinTheme(
                  selectedColor: AppColors.greyColor,
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(14),
                  activeFillColor: AppColors.greyColor,
                  inactiveFillColor: AppColors.greyColor,
                  selectedFillColor: AppColors.greyColor,
                  fieldHeight: size.width * 0.1,
                  fieldWidth: size.width * 0.1,
                  activeColor: AppColors.greyColor,
                ),
                onChanged: (value) {
                  // PIN Code value stores here
                  debugPrint(value);
                  _viewModel.setOtp(value);
                },
              ),
            ),
            const SizedBox(
              height: 67,
            ),
            CustomText(AppStrings.didntreceiveOTP, 14, FontWeight.w400,
                Color.fromRGBO(108, 108, 108, 1)),
            const CustomTextUnerlined(
                AppStrings.resendOtp, 14, FontWeight.w400, AppColors.defaultRed),
            // const SizedBox(
            //   height: 69,
            // ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 43),
              child: StreamBuilder<bool>(
                stream: _viewModel.outputIsOTPValid,
                builder: (context, snapshot){

                  return LargeButton(
                      "Next",
                      const SizedBox(),
                      const Icon(
                        Icons.arrow_forward,
                        color: AppColors.whiteColor,
                        size: 17,
                      ),
                      backgroundColor: AppColors.defaultRed ,
                      onPressed:  () {
                        _viewModel.verifyOtp(controller.text);

                      }
                  );
                },

              ),
            )
          ],
        ),
      ),
    );
  }




  Widget otpReflection() {
    return Container(
      alignment: Alignment.center,
      height: 48,
      width: 221,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12), color: AppColors.greyColor),
      child: Row(
        children:  [
          Expanded(child: SizedBox()),
          CustomText(
             widget.enteredPhone, 16, FontWeight.w700, AppColors.blackColor),
          SizedBox(
            width: 15,
          ),
          IconButton(
            onPressed: (){
              Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (context){
                return PNRegistration();
              }));
            },
           icon:  Icon(Icons.edit),
            color: AppColors.defaultRed,
          ),
          Expanded(child: SizedBox()),
        ],
      ),
    );
  }
}
