
import 'package:attendance/view/widgets/framework/rf_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../api_service/colors.dart';

class RfLoadingPage extends StatelessWidget {

  RfLoadingPage({super.key, this.color});

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SpinKitCircle(
          color: color ??AppColors.primaryColor,
          size: 72.0.w,
        ),
        SizedBox(height: 20.h,),
        RFText(text: "Please Wait")

      ],
    );
  }
}
