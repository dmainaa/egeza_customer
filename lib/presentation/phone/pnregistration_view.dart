import 'package:country_code_picker/country_code_picker.dart';
import 'package:easypark/app/di.dart';
import 'package:easypark/domain/usecase/verify_phone.dart';
import 'package:easypark/presentation/base/base_ui_shell.dart';
import 'package:easypark/presentation/common/state_renderer_impl.dart';

import 'package:easypark/presentation/otp/otp_verification_view.dart';

import 'package:easypark/presentation/phone/pnregistration_viewmodel.dart';
import 'package:easypark/presentation/resources/color_manager.dart';
import 'package:easypark/presentation/resources/string_manager.dart';
import 'package:easypark/presentation/resources/value_manager.dart';
import 'package:easypark/presentation/universal%20widgets/customtext.dart';
import 'package:easypark/presentation/universal%20widgets/largebutton.dart';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';

import '../../app/app_utils.dart';


class PNRegistration extends StatefulWidget {
  const PNRegistration({Key? key}) : super(key: key);

  @override
  State<PNRegistration> createState() => _PNRegistrationState();
}

class _PNRegistrationState extends State<PNRegistration> {


  TextEditingController mobileNumberController = TextEditingController();

  final  PNRegistrationViewModel _viewModel = PNRegistrationViewModel(VerifyPhone());

   String code = "+254";

  int index = 0;

  final AppUtils _appUtils = GetIt.I<AppUtils>();
  _bind(){

    _viewModel.setCountryCode(code);
    _viewModel.registerStreamController.stream.listen((userExists) {
      SchedulerBinding?.instance.addPostFrameCallback((timeStamp) {
        Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) {
                return OTPVerification("${code}-${mobileNumberController.text.substring(0)}");
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

    _viewModel.responseStreamController.stream.listen((isSuccess) {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        Navigator.pop(context);
        showDialog(context: context, builder: (context){
          return _appUtils.getPopUpDialog(isSuccess: isSuccess, context: context, errorMessage: _viewModel.responseMessage, onTryAgain: (){
            Navigator.of(context).pop(true);
            _viewModel.register();
          });
        });
      });
    });

    mobileNumberController.addListener(() {_viewModel.setPhoneNumber(mobileNumberController.text);});
  }


  @override
  void initState() {

    _bind();
  }


  @override
  void didUpdateWidget(PNRegistration oldWidget) {
    super.didUpdateWidget(oldWidget);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: AppColors.whiteColor,

      // body: StreamBuilder<FlowState>(
      //   stream: _viewModel.outputState,
      //   builder: (context, snapshot){
      //     return snapshot.data?.getScreenWidget(context, getContentView(context), (){
      //
      //     }) ?? getContentView(context);
      //   },
      // ),

      body: BaseUiShell(
          loadingStreamController: _viewModel.loadingStreamController,
          contentWidget: getContentView(context),
          messageStreamController: _viewModel.messagesStreamController),

    );
  }


  Widget getContentView(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
        width: size.width,
        height: size.height,
        child: Stack(children: [
            Positioned(
                top: 156, child: SvgPicture.asset("assets/images/ellipse_o.svg")),
            Positioned(
                right: 0,
                top: 495,
                child: SvgPicture.asset("assets/images/ellipse_s.svg")),
            SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 90,
                    width: double.infinity,
                  ),
                  Hero(
                    tag: "company-logo",
                    child: Container(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 35, vertical: 28),
                      height: 118,
                      width: 118,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: AppColors.lightRed,
                      ),
                      child: SizedBox(
                          height: 62,
                          width: 48,
                          child: SvgPicture.asset(
                            "assets/images/union.svg",
                            fit: BoxFit.cover,
                          )),
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                   CustomText(
                      AppStrings.welcomeTo, 14, FontWeight.w400, AppColors.blackColor),
                   CustomText(
                      AppStrings.parkingApp, 32, FontWeight.w800, AppColors.blackColor),
                  const SizedBox(
                    height:  50
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      StreamBuilder<String>(
                        stream: _viewModel.outputCountryCode,
                        builder: (context, snapshot){
                          return CountryCodePicker(
                            padding: const EdgeInsets.all(1.0),
                            onChanged: (country){
                              code = country.dialCode ?? "";
                              debugPrint(country.dialCode);
                              _viewModel.setCountryCode(country.dialCode ?? EMPTY);
                            },
                            initialSelection: code,
                            showCountryOnly: true,
                            hideMainText: true,
                            showOnlyCountryWhenClosed: true,
                            favorite: ["+254", "+255", "+256"],
                          );
                        },

                      ),
                      Expanded(
                        flex: 3,
                        child: Align(
                          // alignment: Alignment.centerLeft,
                          child: Container(

                            child: Padding(
                              padding: const EdgeInsets.only(right: AppSize.s8),
                              child: StreamBuilder<bool>(
                                stream: _viewModel.outputIsPhoneValid,
                                builder: (context, snapshot){
                                  return TextField(

                                    keyboardType: TextInputType.phone,
                                    controller: mobileNumberController,
                                    decoration: InputDecoration(
                                      prefix: Text("$code "),
                                      hintText:  AppStrings.enterMobileNumber,
                                      labelText: AppStrings.enterMobileNumber,
                                      errorText: (snapshot.data ?? true) ? null : AppStrings.enterValidPhone,

                                    ),

                                  );
                                },

                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: size.height *0.1,),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSize.s8),
                    child: StreamBuilder<bool>(
                      stream: _viewModel.outputIsAllInputValid,
                      builder: (context, snapshot){
                        return LargeButton(
                          AppStrings.next,
                          const SizedBox(),
                          const Icon(
                            Icons.arrow_forward,
                            color: AppColors.whiteColor,
                            size: 17,
                          ),
                          backgroundColor: (snapshot.data  ?? false) ? AppColors.defaultRed : Colors.grey,
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            _viewModel.register();

                          },
                        );
                      },

                    ),
                  ),
                  const SizedBox(
                    height: 54,
                  )
                ],
              ),
            ),
          ]),
      );

  }
}


