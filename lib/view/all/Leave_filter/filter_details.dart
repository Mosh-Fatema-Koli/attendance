import 'package:attendance/view/all/Leave/history/cubit/leave_history_state.dart';
import 'package:attendance/view/all/Leave/history/model/leave_model.dart';
import 'package:attendance/view/all/Leave_filter/cubit/leave_filter_cubit.dart';
import 'package:attendance/view/all/Leave_filter/model/filter_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../api_service/colors.dart';
import '../../../../common_controller/MiscController.dart';
import '../../widgets/framework/rf_box_decoration.dart';
import '../../widgets/framework/rf_text.dart';


class FilterDetailsPage extends StatelessWidget {
  final FilterModel leaveDetails;
  bool isLeave;
  FilterDetailsPage({super.key, required this.leaveDetails,required this.isLeave});
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
            text: isLeave==true?"Leave Approval":"WFH Approval",
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
                        RFText(text: isLeave?"Approval":"Work From Home",size: 20,weight: FontWeight.bold,color: AppColors.primaryColor,),
                        SizedBox(height: 10.h),
                        isLeave?Row(
                          children: [
                            RFText(text: "Leave Type:  ",color: AppColors.primaryColor,weight: FontWeight.bold,),
                            RFText(text: leaveDetails.leaveTypes??"Not Found"),
                          ],
                        ):SizedBox(),
                        Row(
                          children: [
                            RFText(text: "Status:  ",color: AppColors.primaryColor,weight: FontWeight.bold,),
                            RFText(text: leaveDetails.status??"Not Found"),
                          ],
                        ),  Row(
                          children: [
                            RFText(text: "Total days:  ",color: AppColors.primaryColor,weight: FontWeight.bold,),
                            RFText(text: " ${leaveDetails.totalDays??"Not Found"}"),
                          ],
                        ),
                  
                        RFText(text: "Request Date: ${leaveDetails.createdAt}"),
                        RFText(text: "Reason: ${leaveDetails.reason}",),
                        SizedBox(height: 10.h),
                        leaveDetails.image !=null? CachedNetworkImage(
                          imageUrl: leaveDetails.image.toString().trim(),
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
                                RFText(text: "${leaveDetails.startDate}"),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RFText(text: "End Date",size: 16.sp,weight: FontWeight.bold,color: AppColors.primaryColor,),
                  
                                RFText(text: "${leaveDetails.endDate}"),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 30.h),
                        
                      ],
                    ),
                  ),
                  leaveDetails.status=="Pending"? BlocProvider(
                      create: (context) => LeaveFilterCubit(),
                      child: BlocConsumer<LeaveFilterCubit, LeaveFilterState>(
                      listener: (context, state) {
                        // TODO: implement listener
                      },
                      builder: (context, state) {

                        return Positioned(
                                          top: 5.h,
                                          right: 0.h,
                                          child: IconButton(onPressed:    () {
                                            print(leaveDetails.id!);
                                            context.read<LeaveFilterCubit>().delete(id: leaveDetails.id!,context: context,isLeave: leaveDetails.leaveTypes==null?false:true,
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
