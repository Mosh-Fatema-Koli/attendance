import 'package:attendance/view/widgets/framework/rf_drop_down.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../api_service/colors.dart';
import '../../../../common_controller/MiscController.dart';
import '../../../widgets/framework/C_button.dart';
import '../../../widgets/framework/rf_box_decoration.dart';
import '../../../widgets/framework/rf_button.dart';
import '../../../widgets/framework/rf_date_picker.dart';
import '../../../widgets/framework/rf_loading_page.dart';
import '../../../widgets/framework/rf_text.dart';
import 'attendence_summary.dart';
import '../component/card.dart';
import '../cubit/history/atteendance_history_cubit.dart';

class HistoryPage extends StatelessWidget {
   HistoryPage({super.key});
  TextEditingController searchController = TextEditingController();
   final miscController = MiscController();

   String month="";
   String year="";

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
            leading: IconButton(onPressed: () {
              miscController.navigateBack(context: context);
            }, icon: Icon(Icons.arrow_back_ios,color: Colors.black,)),
            title:RFText(
              text: "Attendance Summary",color: Colors.black,
              size: 18.sp,
              weight: FontWeight.bold,
            ),
          ),
          body: historyMain(),
      ),
    );
  }

  BlocProvider<AttendanceHistoryCubit> historyMain() {
    return BlocProvider(
      create: (context) => AttendanceHistoryCubit()..loadData(),
      child: BlocConsumer<AttendanceHistoryCubit, AttendanceHistoryState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          if(state is AttendanceHistoryLoadedState){
            return Column(
              children: [
                Padding(
                  padding:EdgeInsets.only(top: 10.h, left: 16.w, right: 16.w),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 6,
                        child: Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 10).w,
                            child: RFDatePicker(
                              maxDate: DateTime.now(),
                              decoration: RFBoxDecoration().build(),
                              hintText: 'Search By Date',
                              prefixIcon: Icon(Icons.date_range_rounded, size: 20.h, color: AppColors.primaryColor,),
                              suffixIcon: Icon(Icons.search_rounded, size: 20.h, color: AppColors.primaryColor,),
                              controller: searchController, onChange: (dateValue, jsonMapResult) {
                              if(searchController.text.isNotEmpty){
                                 context.read<AttendanceHistoryCubit>().filter(date:dateValue);
                              }
                            },
                            )
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                          flex: 2,
                          child: Container(
                            decoration: RFBoxDecoration().build(),
                            child: IconButton(
                              icon: Icon(Icons.refresh, color: AppColors.primaryColor, size: 26.h),
                              onPressed: () {
                                searchController.clear();
                                context.read<AttendanceHistoryCubit>().loadData();
                              },
                            ),
                          )
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                          flex: 2,
                          child: Container(
                            decoration: RFBoxDecoration().build(),
                            child: IconButton(
                              icon: Icon(Icons.filter_list_outlined, color: AppColors.primaryColor, size: 26.h),
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
                                                    month=newValue.toString();
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
                                                    year=newValue.toString();
                                                  },
                                                ),
                                                SizedBox(height: 20),
                                                CButton(buttonText: "Send", onTap: (){
                                                  if(year.isNotEmpty && month.isNotEmpty){
                                                    miscController.navigateTo(context: context,page: AttendanceSummary(month: month,year: year,));
                                                    year="";
                                                    month="";
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
                          )
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: state.listOfData.isNotEmpty ? ListView.builder(
                    padding: EdgeInsets.all(5),
                    shrinkWrap: true,
                    physics: AlwaysScrollableScrollPhysics(),
                    itemCount: state.listOfData.length,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 5),
                      child: AttendanceCard(attendanceHistory: state.listOfData[index],),
                    ),):Expanded(
                      child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 32.h),
                        Image.asset('assets/images/empty.png', color: AppColors.primaryColor, fit: BoxFit.fitHeight, height: 50.h),
                        SizedBox(height: 16.h),
                        RFText(text: 'No data found!', weight: FontWeight.w500, size: 18.sp, color: Colors.black87.withOpacity(0.8)),
                        SizedBox(height: 32.h),
                      ],
                                        ),
                    ),
                ),
              ],
            );
          } else {
            return RfLoadingPage();
          }

        },
),
);
  }
}