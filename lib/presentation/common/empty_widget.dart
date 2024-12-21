import 'package:easypark/presentation/resources/color_manager.dart';
import 'package:flutter/material.dart';

class EmptyWidget extends StatelessWidget {
   String? message;
   VoidCallback? onRefresh;
   bool? showRefresh;
   EmptyWidget(this.message, {Key? key, this.onRefresh, this.showRefresh = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Text(
                  message ?? "", style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 16.0,
                    color: AppColors.textGrey
                ), textAlign: TextAlign.center,),
              ),
            ),
          ),
          const SizedBox(height: 20,),
          IconButton(onPressed: onRefresh ?? (){

          }, icon: const Icon(Icons.refresh, size: 40.0,))

        ],
      ),
    );
  }
}
