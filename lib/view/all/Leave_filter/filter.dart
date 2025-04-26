import 'package:attendance/view/all/Leave_filter/filter_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show BlocBuilder, BlocConsumer, BlocProvider, ReadContext;
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../api_service/colors.dart';
import '../../../common_controller/MiscController.dart';
import '../../widgets/framework/C_button.dart';
import '../../widgets/framework/rf_box_decoration.dart';
import '../../widgets/framework/rf_date_picker.dart';
import '../../widgets/framework/rf_loading_page.dart';
import '../../widgets/framework/rf_text.dart';
import '../Attendance/component/serviceSummaryList.dart';
import '../Attendance/component/summaryCard.dart';
import '../Leave/history/leave_details.dart';
import '../nab_bar.dart';
import 'cubit/leave_filter_cubit.dart';

class FilterPage extends StatelessWidget {

   String? month;
   String? year;
   String? date;
   bool isLeave;

  FilterPage({super.key, this.month,this.year,this.date,required this.isLeave});

  final miscController = MiscController();
   TextEditingController searchController = TextEditingController();
  String Vmonth="";
  String Vyear="";
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LeaveFilterCubit()..loadData(year: year,month: month,date: date,isLeave: isLeave),
      child: Container(

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
              miscController.navigateBack(context: context);
            },
            icon: Icon(Icons.arrow_back_ios, color: Colors.black,size: 18.r,),
          ),
          title: RFText(text: "Search", color: Colors.black, size: 18.sp,weight: FontWeight.bold,),

        ),
        body: BlocBuilder<LeaveFilterCubit, LeaveFilterState>(
          builder: (context, state) {
           return Column(
             children: [
               Padding(
                 padding:EdgeInsets.only(top: 10.h, left: 16.w, right: 16.w),
                 child: Row(
                   children: [
                     Expanded(
                       flex: 8,
                       child:   Padding(
                           padding: const EdgeInsets.symmetric(vertical: 10,).w,
                           child: RFDatePicker(
                             maxDate: DateTime.now(),
                             decoration: RFBoxDecoration().build(),
                             hintText: 'Search By Date',
                             prefixIcon: Icon(Icons.date_range_rounded, size: 20.h, color: AppColors.primaryColor,),
                             suffixIcon: Icon(Icons.search_rounded, size: 20.h, color: AppColors.primaryColor,),
                             controller: searchController,
                             onChange: (dateValue, jsonMapResult) {
                               if(searchController.text.isNotEmpty){
                                 date=searchController.text;
                                 context.read<LeaveFilterCubit>().loadData(date: searchController.text,isLeave: isLeave);
                               }
                             },
        
                           )
                       ),
                     ),
                     SizedBox(width: 10.w),
                     Expanded(
                         flex: 2,
                         child:Container(
                           padding: const EdgeInsets.symmetric(vertical: 3,horizontal: 5).w,
        
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

                               final parentContext = context; // Save the parent context where Provider is available

                               showDialog(
                                 context: context,
                                 barrierDismissible: true,
                                 builder: (BuildContext dialogContext) {
                                   return AlertDialog(
                                     content: Container(
                                       height: 300.w,
                                       width: 250.w,
                                       child: Stack(
                                         children: [
                                           Column(
                                             mainAxisAlignment: MainAxisAlignment.center,
                                             children: [
                                               Text(
                                                 "Choose Option",
                                                 style: TextStyle(
                                                   fontSize: 16,
                                                   fontWeight: FontWeight.bold,
                                                 ),
                                               ),
                                               SizedBox(height: 20.w),
                                               DropdownButtonFormField<String>(
                                                 value: selectedMonth,
                                                 decoration: InputDecoration(
                                                   labelText: "Select Month",
                                                 ),
                                                 items: months.map((String month) {
                                                   return DropdownMenuItem<String>(
                                                     value: month,
                                                     child: Text(month),
                                                   );
                                                 }).toList(),
                                                 onChanged: (String? newValue) {
                                                   if (newValue != null) {
                                                     selectedMonth = newValue;
                                                     month = newValue;
                                                   }
                                                 },
                                               ),
                                               SizedBox(height: 10.w),
                                               DropdownButtonFormField<String>(
                                                 value: selectedYear,
                                                 decoration: InputDecoration(
                                                   labelText: "Select Year",
                                                 ),
                                                 items: years.map((String year) {
                                                   return DropdownMenuItem<String>(
                                                     value: year,
                                                     child: Text(year),
                                                   );
                                                 }).toList(),
                                                 onChanged: (String? newValue) {
                                                   if (newValue != null) {
                                                     selectedYear = newValue;
                                                     year = newValue;
                                                   }
                                                 },
                                               ),
                                               SizedBox(height: 20.w),
                                               CButton(
                                                 buttonText: "Send",
                                                 onTap: () {
                                                   if (year!.isNotEmpty && month!.isNotEmpty) {
                                                     miscController.navigateBack(context: context);
                                                     context.read<LeaveFilterCubit>().loadData(month: month, year: year,isLeave: isLeave);
                                                     // miscController.navigateTo(
                                                     //   context: context,
                                                     //   page: FilterPage(month: month, year: year),
                                                     // );
                                                     year = "";
                                                     month = "";
                                                   } else {
                                                     miscController.toast(msg: "Please select correct date and month");
                                                   }
                                                 },
                                               ),
                                             ],
                                           ),
                                           Positioned(
                                             right: 0,
                                             top: 0,
                                             child: IconButton(
                                               icon: Icon(Icons.cancel, color: Colors.red),
                                               onPressed: () {
                                                 Navigator.of(context).pop();
                                               },
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
        
               state is LeaveFilterLoadedState?
                state.listOfData.isNotEmpty?Expanded(
                  child: ListView.builder(
                    physics: AlwaysScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: state.listOfData.length,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Stack(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 15).w,
                            width: MediaQuery.of(context).size.width,
                            decoration: RFBoxDecoration(color: Colors.white).build(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RFText(text: state.listOfData[index].leaveTypes==null?"Work Form Home":"Approval",size: 20,weight: FontWeight.bold,color: AppColors.primaryColor,),
                                SizedBox(height: 10.h),
                                state.listOfData[index].leaveTypes==null?SizedBox():Row(
                                  children: [
                                    RFText(text: "Leave Type:  ",color: AppColors.primaryColor,weight: FontWeight.bold,),
                                    RFText(text: state.listOfData[index].leaveTypes??"Not Found"),
                                  ],
                                ),
                                Row(
                                  children: [
                                    RFText(text: "Status:  ",color: AppColors.primaryColor,weight: FontWeight.bold,),
                                    RFText(text: state.listOfData[index].status??"Not Found"),
                                  ],
                                ),
                                RFText(text: "Total days: ${state.listOfData[index].totalDays}"),
                                RFText(text: "Request Date: ${state.listOfData[index].createdAt}"),
                                RFText(text: "Reason: ${state.listOfData[index].reason}",maxLines: 1,),
                                SizedBox(height: 10.h),
                                // ListTile(
                                //   contentPadding: EdgeInsets.zero,
                                //   leading: CircleAvatar(child: ClipRRect(
                                //     borderRadius: BorderRadius.circular(100),
                                //     child: Image.network( "http://attendance.mrshakil.com/api${AppCache().userInfo!.image}"),
                                //   ),),
                                //   title: RFText(text: AppCache().userInfo?.name),),
                                Divider(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        RFText(text: "Start Date",size: 16.sp,weight: FontWeight.bold,color: AppColors.primaryColor,),
                                        RFText(text: "${state.listOfData[index].startDate}"),
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        RFText(text: "End Date",size: 16.sp,weight: FontWeight.bold,color: AppColors.primaryColor,),
        
                                        RFText(text: "${state.listOfData[index].endDate}"),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                              top: 25.w,
                              right: 15.w,
                              child: GestureDetector(
                                onTap: () {
                                  miscController.navigateTo(context: context,page: FilterDetailsPage(leaveDetails: state.listOfData[index], isLeave: state.listOfData[index].leaveTypes==null?false:true));
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 20).w,
                                  decoration: RFBoxDecoration(border: Border.all(color: AppColors.primaryColor,width: 2)).build(),
                                  child: RFText(text: "View details",color: AppColors.primaryColor,),),
                              ))
        
        
                        ],
                      ),
                    ),),
                ) : Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 32.h),
                        Image.asset(
                          'assets/images/empty.png',
                          color: AppColors.primaryColor,
                          fit: BoxFit.fitHeight,
                          height: 50.h,
                        ),
                        SizedBox(height: 16.h),
                        RFText(
                          text: 'There is no approval Yet!!',
                          weight: FontWeight.w500,
                          size: 18.sp,
                          color: Colors.black87.withOpacity(0.8),
                        ),
        
                        SizedBox(height: 32.h),
                      ],
                    ),
                  ),
                ):
                Center(child: RfLoadingPage()),
             ],
           );
          },
        ),
      ),
    ),
);
  }
}
