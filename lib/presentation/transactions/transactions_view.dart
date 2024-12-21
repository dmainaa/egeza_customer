import 'package:easypark/app/app_utils.dart';
import 'package:easypark/app/di.dart';
import 'package:easypark/domain/model/model.dart';
import 'package:easypark/domain/usecase/mytransactions_usecase.dart';
import 'package:easypark/presentation/common/empty_widget.dart';
import 'package:easypark/presentation/common/state_renderer_impl.dart';
import 'package:easypark/presentation/resources/color_manager.dart';
import 'package:easypark/presentation/resources/string_manager.dart';
import 'package:easypark/presentation/transactions/transactions_viewmodel.dart';
import 'package:easypark/presentation/universal%20widgets/customtext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../base/base_ui_shell.dart';

class TransactionView extends StatefulWidget {
  const TransactionView({Key? key}) : super(key: key);

  @override
  State<TransactionView> createState() => _TransactionViewState();
}

class _TransactionViewState extends State<TransactionView> {

  TransactionViewModel _viewModel = TransactionViewModel(MyTransactionsUseCase());
  AppUtils get appUtils => instance<AppUtils>();

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

  void _bind(){
    _viewModel.getTransactions();
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
              AppStrings.myTransactions, 16, FontWeight.w700, AppColors.blackColor),
        ),
        body: BaseUiShell(
            loadingStreamController: _viewModel.loadingStreamController,
            contentWidget: getContentView(context),
            messageStreamController: _viewModel.messagesStreamController));
  }

  Widget getContentView(BuildContext context){
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 35,
          decoration: const BoxDecoration(
              color: AppColors.appBarColor,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(28),
                  bottomRight: Radius.circular(28))),
          child:
          CustomText("", 14, FontWeight.w400, AppColors.blackColor),
        ),
        const SizedBox(
          height: 32,
        ),
        Expanded(
            child: StreamBuilder<List<Transaction>>(
              stream: _viewModel.outputgetTransactions,
              builder: (context, snapshot){
                List<Transaction> allTransactions = snapshot.data ?? [];
                return allTransactions.isNotEmpty ? ListView.builder(
                  itemCount: allTransactions.length,
                  itemBuilder: (context, index){
                    return GestureDetector(
                      onTap: (){
                      },
                      child: ListTile(

                        title:  CustomText(allTransactions[index].title, 16, FontWeight.w700,
                            AppColors.blackColor),
                        subtitle:  CustomText("${allTransactions[index].date}", 14,
                            FontWeight.w400, AppColors.blackColor),
                        trailing:  CustomText(
                            "${allTransactions[index].currency} ${allTransactions[index].amount}", 16, FontWeight.w700, allTransactions[index].type == "credit" ? AppColors.green : AppColors.defaultRed),
                      ),
                    );
                  },
                ) : EmptyWidget(AppStrings.noTransactionsAtTheMoment, onRefresh: (){
                  _viewModel.getTransactions();
                },);
              },

            ))
      ],
    );
  }
}
