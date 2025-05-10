import 'package:attendance/view/all/Attendance/cubit/history/atteendance_history_cubit.dart';
import 'package:attendance/view/all/Attendance/cubit/history_filter/attendanceFilterCubit.dart';
import 'package:attendance/view/widgets/framework/rf_loading_page.dart';
import 'package:attendance/view/widgets/framework/rf_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../api_service/colors.dart';
import '../../../../common_controller/MiscController.dart';
import '../../../widgets/framework/C_button.dart';
import '../../../widgets/framework/rf_box_decoration.dart';
import '../../../widgets/framework/rf_button.dart';
import '../../nab_bar.dart';
import '../component/card.dart';
import '../component/serviceSummaryList.dart';
import '../component/summaryCard.dart';
import '../cubit/history_filter/atteendance_filter_state.dart';

class AttendanceSummary extends StatelessWidget {
  final String month;
  final String year;

  AttendanceSummary({super.key, required this.month, required this.year});

  final miscController = MiscController();
  String Vmonth="";
  String Vyear="";
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

            ],
          )),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            onPressed: () {
              miscController.navigateTo(context: context, page: NavbarPage(initialIndex: 1));
            },
            icon: Icon(Icons.arrow_back_ios, color: Colors.black,size: 18.r,),
          ),
           title: RFText(text: "$month $year", color: Colors.black, size: 18.sp,weight: FontWeight.bold,),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10).w,
              child: Container(
                //padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 5).w,

                decoration: RFBoxDecoration().build(),
                child: IconButton(
                  icon: Icon(Icons.filter_list_outlined, color: AppColors.primaryColor, size: 18.r),
                  onPressed: () {
                    String? selectedMonth;
                    String? selectedYear;

                    List<String> months = [
                      "January", "February", "March", "April", "May", "June",
                      "July", "August", "September", "October", "November", "December"
                    ];
                    List<String> years = List.generate(10, (index) => (DateTime.now().year - index).toString());

                    showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          contentPadding: EdgeInsets.symmetric(horizontal: 16),
                          content: Container(
                            height: 300.w,
                            width: 250.w,
                            child: Stack(
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Choose Option", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                    SizedBox(height: 20),
                                    DropdownButtonFormField<String>(
                                      value: selectedMonth,
                                      decoration: InputDecoration(labelText: "Select Month"),
                                      items: months.map((String month) {
                                        return DropdownMenuItem<String>(
                                          value: month,
                                          child: Text(month),
                                        );
                                      }).toList(),
                                      onChanged: (String? newValue) {
                                        selectedMonth = newValue;
                                        Vmonth=newValue.toString();
                                      },
                                    ),
                                    SizedBox(height: 10),
                                    DropdownButtonFormField<String>(
                                      value: selectedYear,
                                      decoration: InputDecoration(labelText: "Select Year"),
                                      items: years.map((String year) {
                                        return DropdownMenuItem<String>(
                                          value: year,
                                          child: Text(year),
                                        );
                                      }).toList(),
                                      onChanged: (String? newValue) {
                                        selectedYear = newValue;
                                        Vyear=newValue.toString();
                                      },
                                    ),
                                    SizedBox(height: 20),
                                    CButton(buttonText: "Send", onTap: (){
                                      if(year.isNotEmpty && month.isNotEmpty){
                                        miscController.navigateTo(context: context,page: AttendanceSummary(month: Vmonth,year: Vyear,));
                                        Vyear="";
                                        Vmonth="";
                                      }else{
                                        miscController.toast(msg: "Please select correct date and month");
                                      }

                                    })
                                  ],
                                ),
                                Positioned(
                                  right: -10,
                                  top: 0,
                                  child: IconButton(
                                    onPressed: () => Navigator.of(context).pop(),
                                    icon: Icon(Icons.cancel, color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );

                  },
                ),
              ),
            )
          ],
        ),
        body: BlocProvider(
          create: (context) => AttendanceFilterCubit()..summaryLoadData(month: month, year: year),
          child: BlocBuilder<AttendanceFilterCubit, AttendanceFilterState>(
            builder: (context, state) {
              if (state is AttendanceFilterLoadedState) {
                bool hasData = state.summary.monthAttendanceSummary != null &&
                    state.summary.monthAttendanceSummary!.isNotEmpty;

                return Padding(
                  padding: const EdgeInsets.all(16).w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RFText(text: "Summary:", size: 20, weight: FontWeight.bold),
                      SizedBox(height: 10.h),
                      serviceSummaryList(context),
                      SizedBox(height: 20.h),
                      RFText(text: "Attendance List:", size: 20, weight: FontWeight.bold),
                      SizedBox(height: 10.h),
                      hasData
                          ? Expanded(
                        child: ListView.builder(
                          padding: EdgeInsets.all(0),
                          itemCount: state.summary.monthAttendanceSummary!.length,
                          itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                            child: SummaryCard(
                              attendanceHistory: state.summary.monthAttendanceSummary![index],
                            ),
                          ),
                        ),
                      )
                          : Expanded( // Ensures proper layout even if no data is found
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/empty.png',
                                color: AppColors.primaryColor,
                                fit: BoxFit.fitHeight,
                                height: 50.h,
                              ),
                              SizedBox(height: 16.h),
                              RFText(
                                text: 'No data found!',
                                weight: FontWeight.w500,
                                size: 18.sp,
                                color: Colors.black87.withOpacity(0.8),
                              ),
                              SizedBox(height: 32.h),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return Center(child: RfLoadingPage());
              }
            },
          ),
        ),
      ),
    );
  }
}
