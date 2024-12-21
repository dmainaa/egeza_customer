

import 'package:easypark/presentation/resources/color_manager.dart';
import 'package:easypark/presentation/resources/string_manager.dart';
import 'package:easypark/presentation/universal%20widgets/customtext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class PaymentSuccessView extends StatefulWidget {

  final bool isSuccess;
  final String billId;
  const PaymentSuccessView(this.billId, this.isSuccess, {Key? key}) : super(key: key);

  @override
  State<PaymentSuccessView> createState() => _PaymentSuccessViewState();
}

class _PaymentSuccessViewState extends State<PaymentSuccessView> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: goBack,
      child: Scaffold(
        backgroundColor: widget.isSuccess ?  Color.fromRGBO(241, 255, 247, 1) : AppColors.errorScreenBackground,
        appBar: AppBar(
          elevation: 0,
          leading: GestureDetector(
            onTap: () {
              goBack();
            },
            child: const Icon(
              Icons.arrow_back,
              color: AppColors.blackColor,
            ),
          ),
          titleSpacing: 0,
          title:
           CustomText(widget.isSuccess ?  AppStrings.confirmed : AppStrings.failed, 16, FontWeight.w700, AppColors.blackColor),
          backgroundColor: widget.isSuccess ?  Color.fromRGBO(241, 255, 247, 1) : AppColors.errorScreenBackground,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    widget.isSuccess ?    "assets/images/paymentmethod/payment_confirmed.svg" : "assets/images/close_ring.svg"),
                  const SizedBox(
                    height: 16,
                  ),
                   CustomText(widget.isSuccess ?  AppStrings.paymentConfirmed : AppStrings.paymentFailed, 20, FontWeight.w700,
                      AppColors.blackColor),
                  const SizedBox(
                    height: 4,
                  ),
                   CustomText(widget.isSuccess? AppStrings.paymentSuccessful : AppStrings.couldntprocessPayment, 14, FontWeight.w500,
                      AppColors.blackColor)
                ],
              ),
            ),
            Container(
              height: 359,
              decoration: BoxDecoration(
                  color: widget.isSuccess ?  const Color.fromRGBO(225, 225, 225, 1) : AppColors.errorScreenBackground,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(28),
                      topRight: Radius.circular(28))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const SizedBox(
                    width: double.infinity,
                  ),
                 widget.isSuccess ?  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                          "assets/images/paymentmethod/information_outline.svg"),
                      const SizedBox(
                        height: 12,
                      ),
                      SizedBox(
                        width: 175,
                        child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(children: [
                              TextSpan(
                                  text: "You have ",
                                  style: GoogleFonts.manrope(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.blackColor)),
                              TextSpan(
                                  text: "2 minutes ",
                                  style: GoogleFonts.manrope(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.blackColor)),
                              TextSpan(
                                  text: "to exit the parking",
                                  style: GoogleFonts.manrope(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.blackColor))
                            ])),
                      )
                    ],
                  ) : Container(),
                  widget.isSuccess ?  Container(
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: CustomText("A receipt will be sent to your email", 13, FontWeight.normal, Colors.black),
                    ),
                  ) : Container(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<bool> goBack()async{
   int count = 0;
   int dispatcher = widget.isSuccess ? 2 : 1;
    Navigator.popUntil(context, (route) {
      return count++ == dispatcher;
    });

    return true;
  }
}
