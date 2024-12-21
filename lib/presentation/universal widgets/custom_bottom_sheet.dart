import 'package:easypark/presentation/check_out/checkout_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../check_out/bill/bill_viewmodel.dart';
import '../resources/color_manager.dart';
import '../resources/string_manager.dart';

import 'customtext.dart';

class ConfirmPaymentBottomSheet extends StatefulWidget {

  final String phone;
  final BillViewModel _viewModel;
  final String billId;

  final String paymentMethod;



  const ConfirmPaymentBottomSheet(this.phone, this._viewModel, this.billId, this.paymentMethod, {Key? key}) : super(key: key);

  @override
  State<ConfirmPaymentBottomSheet> createState() => _ConfirmPaymentBottomSheetState();
}

class _ConfirmPaymentBottomSheetState extends State<ConfirmPaymentBottomSheet> {

  int isPhoneSelected = 0;

  int selected = 0;

  TextEditingController _controller = TextEditingController();


  @override
  void initState() {
    super.initState();
    _bind();
  }

  _bind(){
    _controller.addListener(() {
      setState(() {

      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
      EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      margin: const EdgeInsets.symmetric(horizontal: 32),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SvgPicture.asset("assets/images/parkinginfo/modalbottom.svg"),
            const SizedBox(height: 10,),
            SvgPicture.asset("assets/images/paymentmethod/percent.svg"),
            const SizedBox(height: 10,),
            CustomText(
                AppStrings.confirmPayment, 18, FontWeight.w700,
                AppColors.blackColor),
            CustomText(
                "Pay Using", 16, FontWeight.w700,
                AppColors.blackColor),
            const SizedBox(height: 10,),

            GestureDetector(
              onTap: (){
               setState(() {
                 selected = 0;
               });
              },
                child: down(selected == 0, "0${widget.phone}", "assets/images/paymentmethod/checked.svg")),
            const SizedBox(height: 10,),
            CustomText(
                "Or", 13, FontWeight.w700,
                AppColors.blackColor),
            const SizedBox(height: 10,),
            GestureDetector(
                onTap: (){
                  setState(() {
                    selected = 1;
                  });
                },
                child: down(selected == 1, "Pay using a different number", "assets/images/paymentmethod/checked.svg")),


            const SizedBox(height: 10,),


           selected == 1 ? Container(
              width: 400,
              child: TextField(
                enabled: true,
                controller: _controller,
                decoration: InputDecoration(
                  hintText: AppStrings.phoneNumber,
                  border: new OutlineInputBorder(
                      borderSide: new BorderSide(color: Colors.black)),
                  errorText: _controller.text.length == 10 ?  "": "Enter a valid phone number"


                ),

                keyboardType: TextInputType.phone,


              ),
            ) : Container(),

            // SizedBox(height: MediaQuery.of(context).size.height * 0.05,),

            SizedBox(height: 20,),

            Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      fixedSize: const Size(203, 56),
                      backgroundColor: AppColors.defaultRed),
                  onPressed: () {
                    Navigator.of(context).pop();
                    widget._viewModel.makePayment(widget.billId, widget.paymentMethod ?? "", selected == 0 ? "0${widget.phone}": _controller.text);

                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children:  [
                     const Icon(
                        Icons.credit_card,
                        color: AppColors.whiteColor,
                      ),
                      const SizedBox(
                        width: 13.5,
                      ),
                      CustomText(
                          AppStrings.payNow, 14, FontWeight.w700,
                          AppColors.whiteColor),
                    ],
                  )),
            )


          ],
        ),
      ),

    );
  }
}

Widget down(bool isSelected, String title, String icon) {
  return Container(
    decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(16),
        border: isSelected ? Border.all(color: AppColors.defaultRed) : null),
    child: Center(
      child: ListTile(
        leading: isSelected
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset("assets/images/paymentmethod/checked.svg"),
          ],
        )
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
                "assets/images/paymentmethod/unchecked.svg"),
          ],
        ),
        title: CustomText(title, 16, FontWeight.w600, AppColors.blackColor),


      ),
    ),
  );
}
