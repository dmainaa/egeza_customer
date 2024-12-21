

import 'package:easypark/domain/model/model.dart';
import 'package:easypark/domain/usecase/promotions_usecase.dart';
import 'package:easypark/presentation/common/state_renderer.dart';
import 'package:easypark/presentation/common/state_renderer_impl.dart';
import 'package:easypark/presentation/promotions/promotions_viewmodel.dart';
import 'package:easypark/presentation/resources/color_manager.dart';
import 'package:easypark/presentation/resources/string_manager.dart';
import 'package:easypark/presentation/universal%20widgets/customtext.dart';
import 'package:easypark/presentation/universal%20widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';

import '../../app/app_utils.dart';
import '../base/base_ui_shell.dart';

class PromotionsScreen extends StatefulWidget {
  const PromotionsScreen({Key? key}) : super(key: key);

  @override
  State<PromotionsScreen> createState() => _PromotionsScreenState();
}

class _PromotionsScreenState extends State<PromotionsScreen> {

  final TextEditingController promoCodeController = TextEditingController();

  PromotionsViewModel _viewModel = PromotionsViewModel(PromotionsUseCase());
  final AppUtils _appUtils = GetIt.I<AppUtils>();


  @override
  void initState() {
    super.initState();
    _bind();
  }

  _bind(){
    _viewModel.start();
    _viewModel.getPromotions();
    _viewModel.redeemCodeStreamController.stream.listen((isSuccess) {

      if(isSuccess){
        _viewModel.messagesStreamController.add([true, "Code redeemed successfully"]);
      }else{
        _viewModel.messagesStreamController.add([false, "Failed to redeem Code"]);
      }

    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: appBar(context),
        body: BaseUiShell(
            loadingStreamController: _viewModel.loadingStreamController,
            contentWidget: getContentView(context),
            messageStreamController: _viewModel.messagesStreamController));
  }

  Widget getContentView(BuildContext context){
    return StreamBuilder<List<Promotion>>(
      stream: _viewModel.outputGetPromotions,
      builder: (context, snapshot){
        List<Promotion> thePromotions = snapshot.data ?? [];
        return Column(
          children: [
            Container(
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
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      controller:  promoCodeController,
                      decoration: InputDecoration(
                        hintText: AppStrings.enterCode,
                        suffix: GestureDetector(
                          onTap: (){
                            if(promoCodeController.text.isNotEmpty){
                              _viewModel.redeemCode(promoCodeController.text);
                            }

                          },
                          child: Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: CustomText(
                                AppStrings.apply, 14, FontWeight.w700, AppColors.defaultRed),
                          ),
                        ),

                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),
                  SvgPicture.asset("assets/images/promotion_disclaimer.svg")
                ],
              ),
            ),

           thePromotions.isNotEmpty ? Container() : SizedBox(
              height: 120,
              child: TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0, end: 100),
                duration: const Duration(milliseconds: 500),
                builder: (context, value, child) => Padding(
                  padding: EdgeInsets.only(top: value),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomText(AppStrings.noCode, 16, FontWeight.w600, AppColors.blackColor),
                      CustomTextUnerlined(
                          AppStrings.getFreeParking, 16, FontWeight.w600, AppColors.defaultRed)
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 26,),
           thePromotions.isNotEmpty ? Container() :  SvgPicture.asset("assets/images/promotion_sticker.svg"),
            const SizedBox(height: 20,),
            Expanded(
              child: thePromotions.isEmpty ? Container(): ListView.builder(
                  itemCount: thePromotions.length,
                  itemBuilder: (context, index){
                    return ListTile(

                      title:  CustomText(thePromotions[index].title, 16, FontWeight.w700,
                          AppColors.blackColor),
                      subtitle:  CustomText("Expiry: ${thePromotions[index].expiry}", 14,
                          FontWeight.w400, AppColors.blackColor),
                      trailing:  CustomText(
                          "${thePromotions[index].amount}", 16, FontWeight.w700, AppColors.blackColor),
                    );
                  }),
            ),

          ],
        );
      },

    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: AppColors.appBarColor,
      leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop(true);
          },
          child: const Icon(
            Icons.arrow_back,
            color: AppColors.blackColor,
          )),
      titleSpacing: 0,
      title:  Hero(
        tag: 'promotions',
        child: CustomText(
            AppStrings.promotions, 16, FontWeight.w700, AppColors.blackColor),
      ),
    );
  }
}
