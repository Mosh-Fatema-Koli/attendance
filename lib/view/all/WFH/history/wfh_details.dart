import 'package:attendance/api_service/Constant.dart';
import 'package:attendance/view/all/Leave/history/model/leave_model.dart';
import 'package:attendance/view/all/WFH/history/cubit/wfh_history_state.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../api_service/colors.dart';
import '../../../../common_controller/MiscController.dart';
import '../../../widgets/framework/C_button.dart';
import '../../../widgets/framework/rf_box_decoration.dart';
import '../../../widgets/framework/rf_text.dart';
import '../../Leave/history/cubit/leave_history_cubit.dart';
import 'cubit/wfh_history_cubit.dart';

class WFHDetailsPage extends StatelessWidget {
  final LeaveModel wfhDetails;
  WFHDetailsPage({super.key, required this.wfhDetails,});
  final MiscController miscController = MiscController();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.appbarColor,
              AppColors.bodyColor,
              AppColors.bodyColor,
              AppColors.bodyColor,
              AppColors.bodyColor,
              AppColors.bodyColor,


            ],
          )),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(onPressed: () {
            miscController.navigateBack(context: context);
          }, icon: Icon(Icons.arrow_back_ios,color: Colors.black,)),

          title:RFText(
            text: "WFH Approval",
            size: 18.sp,
            color: Colors.black,
            weight: FontWeight.bold,
          ),
        ),
        body:  Padding(
          padding: const EdgeInsets.all(20).w,
          child: Wrap(
            children: [
              Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 15).w,
                    width: MediaQuery.of(context).size.width,
                    decoration: RFBoxDecoration(color: Colors.white).build(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RFText(text: "Work From Home",size: 20,weight: FontWeight.bold,color: AppColors.primaryColor,),
                        SizedBox(height: 10.h),
                        Row(
                          children: [
                            RFText(text: "Status:  ",color: AppColors.primaryColor,weight: FontWeight.bold,),
                            RFText(text: wfhDetails.status??"Not Found"),
                          ],
                        ),  Row(
                          children: [
                            RFText(text: "Total days:  ",color: AppColors.primaryColor,weight: FontWeight.bold,),
                            RFText(text: " ${wfhDetails.totalDays??"Not Found"}"),
                          ],
                        ),

                        RFText(text: "Request Date: ${wfhDetails.createdAt}"),
                        RFText(text: "Reason: ${wfhDetails.reason}",),
                        SizedBox(height: 10.h),
                        // ListTile(
                        //   contentPadding: EdgeInsets.zero,
                        //   leading: CircleAvatar(child: ClipRRect(
                        //     borderRadius: BorderRadius.circular(100),
                        //     child: Image.network( "http://attendance.mrshakil.com/api${AppCache().userInfo!.image}"),
                        //   ),),
                        //   title: RFText(text: AppCache().userInfo?.name),),
                        wfhDetails.image !=null? CachedNetworkImage(
                          imageUrl: "${Constant.imageUrl}${wfhDetails.image}",
                          imageBuilder: (context, imageProvider) => Container(
                            height: 200.h,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          placeholder: (context, url) => SizedBox(child: SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator())),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                        ):SizedBox(),
                        Divider(),
                        SizedBox(height: 10.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RFText(text: "Start Date",size: 16.sp,weight: FontWeight.bold,color: AppColors.primaryColor,),
                                RFText(text: "${wfhDetails.startDate}"),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RFText(text: "End Date",size: 16.sp,weight: FontWeight.bold,color: AppColors.primaryColor,),

                                RFText(text: "${wfhDetails.endDate}"),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 30.h),

                      ],
                    ),
                  ),
                  wfhDetails.status=="Pending"? BlocProvider(
                    create: (context) => WFHHistoryCubit(),
                    child: BlocConsumer<WFHHistoryCubit, WFHHistoryState>(
                      listener: (context, state) {
                        // TODO: implement listener
                      },
                      builder: (context, state) {

                        return Positioned(
                            top: 5.h,
                            right: 0.h,
                            child: IconButton(onPressed:    () {
                              print(wfhDetails.id!);
                              context.read<WFHHistoryCubit>().delete(id: wfhDetails.id!,context: context,
                                onComplete:(isSuccess, message) {
                                  isSuccess?miscController.navigateBack(context: context):miscController.toast(msg: message);
                                }, );
                            }, icon: Icon(Icons.delete,color: AppColors.primaryColor,)));
                      },
                    ),
                  ):SizedBox()
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
}
