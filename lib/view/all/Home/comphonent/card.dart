

import 'package:attendance/view/all/Attendance/model/attendance_history.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../common_controller/MiscController.dart';
import '../../../../api_service/colors.dart';
import '../../../widgets/framework/rf_text.dart';
import '../model/dashboard_model.dart';

class CardList extends StatelessWidget {
  final _miscController = MiscController();
  final CurrentMonthAttendance attendanceHistory;
  CardList({super.key,required this.attendanceHistory});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only( bottom: 10.h, ),
      child: GestureDetector(
          onTap: () async {
            //  onClick(room);
          },
          child:Stack(
            children: [
              GestureDetector(
                onTap: () {
                  buildShowCustomWidgetDialog(context);
                },
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8).r,
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.withOpacity(0.4), width: 0.2.w),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: const Offset(0, 2), // changes position of shadow
                        ),
                      ]),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 12).w,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 1,
                          child:  Icon(attendanceHistory.status=="Present"?Icons.check_box:Icons.close,size: 30,color: attendanceHistory.status=="Present"?AppColors.primaryColor:Colors.red,),
                        ),
                        SizedBox(width: 10.w,),
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(attendanceHistory.day??"Day Not Found",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87.withOpacity(0.8)),
                              ),
                              Text(attendanceHistory.date??"Not Found",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87.withOpacity(0.8)),
                              ),


                            ],
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Check In",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87.withOpacity(0.8)),
                              ),
                              Text(
                                "${attendanceHistory.checkIn?.substring(0,5) ??"Not Found"}",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87.withOpacity(0.8)),
                              ),


                            ],
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("CheckOut",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87.withOpacity(0.8)),
                              ),
                              Text(attendanceHistory.checkOut?.substring(0,5)??"Not Found",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87.withOpacity(0.8)),
                              ),


                            ],
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                  right: -5,
                  top: -5,
                  child: IconButton(onPressed: () {
                    buildShowCustomWidgetDialog(context);
                  }, icon: Icon(Icons.double_arrow,color: AppColors.primaryColor,size: 20,)))

            ],
          )
      ),
    );
  }

  Future<dynamic> buildShowCustomWidgetDialog(BuildContext context) {
    return _miscController.showCustomWidgetDialog(context: context, cancelable: true, dialogContent: SizedBox(
      height: 200.h,
      child: Padding(
        padding: const EdgeInsets.all(15).w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(attendanceHistory.date??"Not Found",
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87.withOpacity(0.8)),
            ),
            SizedBox(height: 10.h,),
            Divider(),
            SizedBox(height: 10.h,),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.fact_check,size: 20.w,),
                SizedBox(width: 5,),
                RFText(text: "Check IN: ${attendanceHistory.checkIn?.substring(0,8)??"Not Found"}",),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.exit_to_app,size: 20.w,),
                SizedBox(width: 5,),
                RFText(text: "Check Out: ${attendanceHistory.checkOut?.substring(0,8)??"Not Found"}",),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.watch_later,size: 20.w,),
                SizedBox(width: 5,),
                RFText(text: "Late: ${attendanceHistory.lateHours??"Not Found"}",),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.elderly,size: 20.w,),
                SizedBox(width: 5,),
                RFText(text: "Early: ${attendanceHistory.earlyHours??"Not Found"}",),
              ],
            ),
          ],
        ),
      ),
    ),);
  }
}
