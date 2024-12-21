import 'package:easypark/app/app_utils.dart';
import 'package:easypark/app/di.dart';
import 'package:easypark/domain/model/model.dart';
import 'package:easypark/domain/usecase/myaccount_usecase.dart';
import 'package:easypark/presentation/common/state_renderer_impl.dart';
import 'package:easypark/presentation/payment/payment_view_model.dart';
import 'package:easypark/presentation/resources/color_manager.dart';
import 'package:easypark/presentation/resources/string_manager.dart';
import 'package:easypark/presentation/transactions/transactions_view.dart';
import 'package:easypark/presentation/universal%20widgets/customtext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../base/base_ui_shell.dart';

class PaymentScreenView extends StatefulWidget {
  const PaymentScreenView({Key? key}) : super(key: key);

  @override
  State<PaymentScreenView> createState() => _PaymentScreenViewState();
}

class _PaymentScreenViewState extends State<PaymentScreenView> {

  PaymentViewModel _viewModel = PaymentViewModel(MyAccountUseCase());
  AppUtils get _appUtils => instance<AppUtils>();
  _bind(){
    _viewModel.getAccountDetails();
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
        elevation: 0,
        backgroundColor: AppColors.appBarColor,
        titleSpacing: 0,
        leading: GestureDetector(
            onTap: (){
              Navigator.of(context).pop(true);
            },
            child: const Icon(
              Icons.arrow_back,
              color: AppColors.blackColor,
            )),
        title: CustomText(
            AppStrings.payment, 16, FontWeight.w700, AppColors.blackColor),
      ),
        body: RefreshIndicator(
          onRefresh: () async {
            _viewModel.getAccountDetails();
          },
          child: BaseUiShell(
              loadingStreamController: _viewModel.loadingStreamController,
              contentWidget: getContentView(context),
              messageStreamController: _viewModel.messagesStreamController),
        ));
  }


  Widget getContentView(BuildContext context){
    return StreamBuilder<MyAccount>(
      stream: _viewModel.outputgetAccountDetails,
      builder: (context, snapshot){
        MyAccount? myAccount = snapshot.data;
        return Column(
          children: [
            Hero(
              tag: 'header',
              child: Container(
                alignment: Alignment.center,
                height: 200,
                width: double.infinity,
                decoration: const BoxDecoration(
                    color: AppColors.appBarColor,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(32),
                        bottomRight: Radius.circular(32))),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomText(AppStrings.currentBalance, 14, FontWeight.w500,
                        AppColors.blackColor),
                    const SizedBox(
                      height: 12,
                    ),
                    Container(
                      height: 61,
                      width: 207,
                      decoration: BoxDecoration(
                          color: AppColors.whiteColor,
                          borderRadius: BorderRadius.circular(16)),
                      child: Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomText( "${myAccount?.currency ?? ""} ${myAccount?.balance ?? ""}" , 20, FontWeight.w700,
                                AppColors.blackColor),
                            const SizedBox(
                              width: 12,
                            ),
                            InkWell(
                              onTap: () {
                                showModalBottomSheet(
                                  isScrollControlled: true,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(16),
                                          topRight: Radius.circular(16))),
                                  context: context,
                                  builder: (context) {
                                    return bottomSheet(context);
                                  },
                                );
                              },
                              child: Container(
                                  height: 20,
                                  width: 20,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      border:
                                      Border.all(color: AppColors.defaultRed)),
                                  child: const Icon(
                                    Icons.question_mark_outlined,
                                    size: 15,
                                    color: AppColors.defaultRed,
                                  )),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 28,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      backgroundColor: AppColors.defaultRed,
                      fixedSize: Size(MediaQuery
                          .of(context)
                          .size
                          .width, 56)),
                  onPressed: () {
                    _appUtils.route(context, TransactionView());
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.lock_clock,
                        color: AppColors.whiteColor,
                      ),
                      const SizedBox(
                        width: 14,
                      ),
                      CustomText(AppStrings.myTransactions, 14, FontWeight.w700,
                          AppColors.whiteColor),


                    ],
                  )),
            ),
            const SizedBox(
              height: 12,
            ),
            const Divider(),

          ],
        );
      },

    );
  }

  Widget bottomSheet(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.2,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 20,),
          SvgPicture.asset("assets/images/parkinginfo/modalbottom.svg"),
          const SizedBox(height: 20,),
          CustomText(AppStrings.depositFundsInYourWalletUsingPaybill, 16,
              FontWeight.w700, AppColors.blackColor),
          const SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: CustomText(
                    "${AppStrings.paybill}:", 16, FontWeight.bold, AppColors.blackColor),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: CustomText(
                      AppStrings.paybillNumber, 15, FontWeight.w600, Colors.blueAccent),
                ),
              )
            ],
          ),
          const SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: CustomText(
                    "${AppStrings.acc}:", 16, FontWeight.bold, AppColors.blackColor),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: CustomText(
                      AppStrings.phoneNumber, 15, FontWeight.w600, AppColors.blackColor),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

}






