import 'package:attendance/api_service/app_cash.dart';
import 'package:attendance/view/widgets/framework/rf_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../common_controller/MiscController.dart';
import '../../../api_service/colors.dart';
import '../../all/Profile/profile_page.dart';


class RFAppBar extends StatelessWidget {
  const RFAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('EEEE, dd MMM yyyy').format(now);

    final MiscController _miscController = MiscController();
    return AppBar(
      backgroundColor: AppColors.primaryColor,
      automaticallyImplyLeading: false,
      title:ListTile(
        contentPadding: EdgeInsets.only(top: 15),
        leading: CircleAvatar(radius: 20.r,
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(2.0).w,
            child:   AppCache().userInfo!.image !=null? CachedNetworkImage(
              imageUrl: AppCache().userInfo!.image.toString(),
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                      colorFilter:
                      ColorFilter.mode(Colors.red, BlendMode.colorBurn)),
                ),
              ),
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Image.asset("assets/images/man.png",fit: BoxFit.contain,),
            ):Image.asset("assets/images/man.png",fit: BoxFit.contain,),
          ),
        ),
        title: RFText(text: "Welcome, ${AppCache().userInfo!.name}",size: 14.sp,weight: FontWeight.bold,color: AppColors.save_white,),
        subtitle: RFText(
          text: formattedDate.toString(),
          size: 20.sp,
          color: AppColors.save_white,
        ),
      ) ,

    );


  }
}