import 'package:easypark/domain/model/model.dart';
import 'package:easypark/domain/usecase/bill_usecase.dart';
import 'package:easypark/presentation/base/base_ui_shell.dart';
import 'package:easypark/presentation/check_out/bill/bill_viewmodel.dart';
import 'package:easypark/presentation/common/state_renderer.dart';
import 'package:easypark/presentation/common/state_renderer_impl.dart';
import 'package:easypark/presentation/payment/payment_screen_view.dart';
import 'package:easypark/presentation/payment/payment_success_view.dart';
import 'package:easypark/presentation/resources/color_manager.dart';
import 'package:easypark/presentation/resources/string_manager.dart';
import 'package:easypark/presentation/universal%20widgets/customtext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:easypark/presentation/universal%20widgets/custom_bottom_sheet.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';

import '../../app/app_utils.dart';

class CheckOutView extends StatefulWidget {
  final String billId;

  const CheckOutView(this.billId, {Key? key}) : super(key: key);

  @override
  State<CheckOutView> createState() => _CheckOutViewState();
}

class _CheckOutViewState extends State<CheckOutView> {
  final BillViewModel _viewModel = BillViewModel(BillUseCase());
  final TextEditingController _controller = TextEditingController();
  int selected = 0;
  String paymentMethodId = "";
  String phoneNumber = "";

  _bind() {
    _viewModel.getBill(widget.billId);
    _viewModel.makePaymentStreamControler.stream.listen((paymentStatus) {
      SchedulerBinding?.instance.addPostFrameCallback((timeStamp) {
        _viewModel.confirmPayment(widget.billId, paymentMethodId, _controller.text);

        print(paymentStatus.message);
        showModalBottomSheet(
          isScrollControlled: true,
          isDismissible: false,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16))),
          context: context,
          builder: (context) {
            return awaitingPaymentBottomSheet(context, paymentStatus);
          },
        );

        _viewModel.isPaymentConfirmedStreamController.stream.listen((paymentSuccess) {
          SchedulerBinding?.instance.addPostFrameCallback((timeStamp) {
            Navigator.of(context).pop(true);
            Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder:
                      (context, animation, secondaryAnimation) {
                    return PaymentSuccessView(widget.billId, paymentSuccess);
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
      });

    });
  }


  @override
  void initState() {
    super.initState();
    _bind();
  }


  @override
  void dispose() {
    super.dispose();
    _viewModel.dispose();
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
            Icons.arrow_back,
            color: AppColors.blackColor,
          ),
        ),
        title: CustomText(
            AppStrings.checkout, 16, FontWeight.w700, AppColors.blackColor),
      ),
      body: BaseUiShell(
          loadingStreamController: _viewModel.loadingStreamController,
          contentWidget: getContentView(context),
          messageStreamController: _viewModel.messagesStreamController),

    );
  }

  Widget getContentView(BuildContext context) {

    return StreamBuilder<Bill>(
      stream: _viewModel.outputGetBill,
      builder: (context, snapshot) {
        Bill? bill = snapshot.data;
        return ListView(
          children: [
            Column(children: [
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
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(100)),
                      child: const Center(
                        child: Icon(
                          Icons.wallet_rounded,
                          size: 33,
                          color: AppColors.defaultRed,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 37,
              ),
              CustomText(
                  AppStrings.youWillPay, 14, FontWeight.w500,
                  AppColors.blackColor),
              const SizedBox(
                height: 12,
              ),
              Container(
                height: 61,
                width: 200,
                decoration: BoxDecoration(
                    color: const Color.fromRGBO(235, 235, 235, 1),
                    borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Center(
                    child: CustomText(
                        "${bill?.currency ?? ""} ${bill?.total_payable ?? ""}",
                        24, FontWeight.w700, AppColors.blackColor),
                  ),
                ),
              ),
              const SizedBox(
                height: 13,
              ),
              GestureDetector(
                onTap: () =>
                    showModalBottomSheet(
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16))),
                      context: context,
                      builder: (context) {
                        return bottomSheet(context, bill);
                      },
                    ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomText(AppStrings.showDetails, 16, FontWeight.w600,
                        AppColors.defaultRed),
                    const Icon(
                      Icons.arrow_drop_down_outlined,
                      color: AppColors.defaultRed,
                    )
                  ],
                ),
              )
            ]),

            const SizedBox(
              height: 65,
            ),
            SizedBox(height: 450, child: paymentMethodContainer(bill))
          ],
        );
      },
    );
  }

  Widget paymentMethodContainer(Bill? bill) {
    return Container(
        decoration: const BoxDecoration(
            color: AppColors.paymentMethodColor,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(28), topRight: Radius.circular(28))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            CustomText(AppStrings.selectPaymentMethod, 16, FontWeight.w700,
                AppColors.blackColor),
            const SizedBox(
              height: 10,
            ),

                ListView.builder(
                  shrinkWrap: true,
                  primary: false,
                  itemCount: bill?.paymentMethods.length ?? 0,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                        onTap: () {
                          _viewModel.inputSelected.add(index);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                              bottom: 20, right: 45, left: 45),
                          child: StreamBuilder<int>(
                              stream: _viewModel.outputSelected,
                              builder: (context, snapshot) {
                                selected = snapshot.data ?? 0;

                                return down(
                                  selected == index,
                                  bill?.paymentMethods[index].title ?? "",
                                  bill?.paymentMethods[index].icon ?? "",
                                );
                              }),
                        ));
                  },
                ),


            Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      fixedSize: const Size(203, 56),
                      backgroundColor: AppColors.defaultRed),
                  onPressed: () {
                    showModalBottomSheet(
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16))),
                      context: context,
                      builder: (context) {
                         return ConfirmPaymentBottomSheet(bill?.phonenumber ?? "", _viewModel, widget.billId ?? "", bill?.paymentMethods[selected].id.toString() ?? "");
                      },
                    );
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
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

        )
    );
  }

  void showPaymentDialog(Widget view){
    Dialog dialog = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      elevation: 1.5,
      child: view,

    );
    showDialog(context: context, builder: (BuildContext context) => dialog);
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

          trailing: SvgPicture.asset(icon),
        ),
      ),
    );
  }

  Widget awaitingPaymentBottomSheet(BuildContext context, PaymentStatus  status) {

    return Container(
      padding: EdgeInsets.only(bottom: 20),
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SvgPicture.asset("assets/images/parkinginfo/modalbottom.svg"),
            SizedBox(height: 10,),
            SvgPicture.asset("assets/images/paymentmethod/percent.svg"),
            SizedBox(height: 10,),
            // Padding(padding: EdgeInsets.symmetric(horizontal: 5.0), child: Text(
            //   status.message,
            //   style: ,
            // ),),
            Text(status.message,
              textAlign:  TextAlign.center,
              style: GoogleFonts.manrope(
                  fontSize: 13.0, fontWeight: FontWeight.w300, color: status.status ? Colors.blueAccent : AppColors.textGrey),),
            SizedBox(height: 10,),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text( "${AppStrings.paybill}: ${status.paybill} ", style: GoogleFonts.manrope(
                    fontSize: 13, fontWeight: FontWeight.w300, color: Colors.black), textAlign: TextAlign.left,),
              ),
            ),

            SizedBox(height: 10,),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text( "${AppStrings.account}: ${status.account.toString()} ", style: GoogleFonts.manrope(
                    fontSize: 13, fontWeight: FontWeight.w300, color: Colors.black), textAlign: TextAlign.left),
              ),
            ),
            const SizedBox(height: 10,),
            Align(alignment: Alignment.center, child: Container(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            ),),
            const SizedBox(height: 10,),
            CustomText(
                AppStrings.waitingPay, 13, FontWeight.w700,
            Colors.blue),
            const SizedBox(height: 10,),
          ],
        ),
      ),

    );
  }

  Widget confirmTransactionBottomSheet(BuildContext context, PaymentMethod? method, String phone) {


    paymentMethodId = method?.id.toString() ?? "";

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
                  AppStrings.confirmPayment, 16, FontWeight.w700,
                  AppColors.blackColor),

              const SizedBox(height: 10,),
          Container(
                width: 200,
                child: TextField(
                    enabled: true,
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: AppStrings.phoneNumber,
                    ),

                  keyboardType: TextInputType.phone,
                ),
              ),
              const SizedBox(height: 20,),
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
                      _viewModel.makePayment(widget.billId, method?.id.toString() ?? "", _controller.text);

                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.credit_card,
                          color: AppColors.whiteColor,
                        ),
                        SizedBox(
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

  Widget bottomSheet(BuildContext context, Bill? bill) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SvgPicture.asset("assets/images/parkinginfo/modalbottom.svg"),
          SvgPicture.asset("assets/images/paymentmethod/percent.svg"),
          CustomText(
              AppStrings.billBreakdown, 16, FontWeight.w700,
              AppColors.blackColor),
          Row(
            children: [
              Expanded(
                  child: CustomText(AppStrings.youWillPay, 14,
                      FontWeight.w500, AppColors.blackColor)),
              CustomText(
                  " ${bill?.currency ?? ""} ${bill?.total_payable ?? ""}", 14,
                  FontWeight.w500, AppColors.blackColor)
            ],
          ),
          Row(
            children: [
              Expanded(
                child: CustomText(
                    "VAT ${bill?.vat_rate ?? ""} % ", 14,
                    FontWeight.w500, AppColors.blackColor),
              ),
              
              CustomText(
                  "${bill?.currency } ${bill?.vat_amount}", 14, FontWeight.w500,
                  AppColors.blackColor)
            ],
          ),
          Row(
            children: [
              Expanded(
                  child: CustomText(AppStrings.discount, 14, FontWeight.w500,
                      AppColors.blackColor)),
              CustomText(
                  "KES ${bill?.discount ?? ""}", 14, FontWeight.w500, AppColors.blackColor)
            ],
          ),
          Row(
            children: [
              Expanded(
                  child: CustomText(AppStrings.totalPayable, 14, FontWeight.w500,
                      AppColors.blackColor)),
              CustomText(
                  "KES ${bill?.total_payable ?? ""}", 14, FontWeight.w500, AppColors.blackColor)
            ],
          ),

          Row(
            children: [
              Expanded(
                  child: CustomText(AppStrings.amountPaid, 14, FontWeight.w500,
                      AppColors.blackColor)),
              CustomText(
                  "KES ${bill?.total_paid ?? ""}", 14, FontWeight.w500, AppColors.blackColor)
            ],
          ),

          const Divider(
            color: AppColors.modalBottom,
          ),
          Row(
            children: [
              Expanded(
                  child: CustomText(
                      AppStrings.total, 18, FontWeight.w700,
                      AppColors.blackColor)),
              CustomText(bill?.to_pay.toString() ?? "", 18, FontWeight.w700,
                  AppColors.blackColor)
            ],
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                 fixedSize:  const Size(210, 56),
                  backgroundColor: AppColors.defaultRed,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16))),
              onPressed: () {
                Navigator.of(context).pop(true);

              },
              child: CustomText(
                  AppStrings.ok, 14, FontWeight.w700, AppColors.whiteColor)),
        ],
      ),
    );
  }
}
