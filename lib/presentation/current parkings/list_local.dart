import 'package:cached_network_image/cached_network_image.dart';
import 'package:easypark/presentation/resources/color_manager.dart';
import 'package:easypark/presentation/universal%20widgets/customtext.dart';
import 'package:flutter/material.dart';

class ListLocal extends StatelessWidget {
  final String leadingText;

  final String title;
  final String subtitle;
  final String trailing;


  const ListLocal(this.leadingText, this.subtitle,
      this.title, this.trailing,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Container(
            height: 54,
            width: 54,
            decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: CachedNetworkImageProvider(
                    leadingText
                  )
                ),
                borderRadius: BorderRadius.circular(100)),

          ),
          title: CustomText(title, 14, FontWeight.w700, AppColors.blackColor),
          subtitle:
          CustomText(subtitle, 12, FontWeight.w400, AppColors.blackColor),
          trailing:
          CustomText("KES ${trailing}", 14, FontWeight.w700, AppColors.blackColor),
        ),
         Divider(
          color: AppColors.dividerColor,
          thickness: 1,
        )
      ],
    );
  }
}