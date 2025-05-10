import 'package:attendance/api_service/app_cash.dart';
import 'package:attendance/view/all/Leave/history/cubit/leave_history_state.dart';
import 'package:attendance/view/all/Leave/history/leave_details.dart';
import 'package:attendance/view/all/nab_bar.dart';
import 'package:attendance/view/widgets/framework/rf_loading_page.dart';
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
import '../../../widgets/framework/rf_text.dart';
import '../../Leave_filter/filter.dart';
import '../leave_entry/leave_entry.dart';
import 'cubit/leave_history_cubit.dart';


class LeaveHistoryPage extends StatelessWidget {
   LeaveHistoryPage({super.key});
  final miscController = MiscController();
   TextEditingController searchController = TextEditingController();
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
      child: BlocProvider(
      create: (context) => LeaveHistoryCubit()..loadData(),
      child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
                leading: IconButton(onPressed: () {
                  miscController.navigateTo(context: context, page: NavbarPage(initialIndex: 1));
                }, icon: Icon(Icons.arrow_back_ios,color: Colors.black,)),

                title:RFText(
                  text: "Leave Approval",
                  size: 18.sp,
                  color: Colors.black,
                  weight: FontWeight.bold,
                ),
              ),
            body: BlocConsumer<LeaveHistoryCubit, LeaveHistoryState>(
            listener: (context, state) {
              // TODO: implement listener
            },
            builder: (context, state) {
              return Center(
                        child: Column(
                          children: [
                            Padding(
                              padding:EdgeInsets.only(top: 10.h, left: 16.w, right: 16.w),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 8,
                                    child: Padding(
                                        padding: const EdgeInsets.only(top: 10, bottom: 10).w,
                                        child: RFDatePicker(
                                          maxDate: DateTime.now(),
                                          decoration: RFBoxDecoration().build(),
                                          hintText: 'Search By Date',
                                          prefixIcon: Icon(Icons.date_range_rounded, size: 20.h, color: AppColors.primaryColor,),
                                          suffixIcon: Icon(Icons.search_rounded, size: 20.h, color: AppColors.primaryColor,),
                                          controller: searchController,
                                          onChange: (dateValue, jsonMapResult) {
                                          if(searchController.text.isNotEmpty){
                                          //  context.read<AttendanceHistoryCubit>().filter(date:dateValue);
                                            miscController.navigateTo(context: context,page: FilterPage(date: searchController.text,isLeave: true,));
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
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 3).w,
                                          child: IconButton(
                                            icon: Icon(Icons.filter_list_outlined, color: AppColors.primaryColor, size: 20.h),
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
                                                                  miscController.navigateBack(context: context);
                                                                  miscController.navigateTo(context: context,page: FilterPage(month: month,year: year,isLeave: true,));
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
                                        ),
                                      )
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10.h,),

                            state is LeaveHistoryLoadedState?
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
                                          RFText(text: "Approval",size: 20,weight: FontWeight.bold,color: AppColors.primaryColor,),
                                          SizedBox(height: 10.h),
                                          Row(
                                            children: [
                                              RFText(text: "Leave Type:  ",color: AppColors.primaryColor,weight: FontWeight.bold,),
                                              RFText(text: state.listOfData[index].leaveTypes??"Not Found"),
                                            ],
                                          ),   Row(
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
                                            miscController.navigateTo(context: context,page: LeaveDetailsPage(leaveDetails: state.listOfData[index],isLeave: true,));
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
                                    text: 'There is no approval Yet!!',
                                    weight: FontWeight.w500,
                                    size: 18.sp,
                                    color: Colors.black87.withOpacity(0.8),
                                  ),
                                  SizedBox(height: 32.h),
                                  SizedBox(height: 32.h),
                                ],
                              ),
                            ):
                            Center(child: RfLoadingPage()),


                          ],
                        ),
                      );
            },
          ),
                      bottomNavigationBar: Wrap(
                        children: [
                          SafeArea(
                            child: Padding(
                              padding: const EdgeInsets.all(15.0).w,
                              child: CButton(buttonText: "Make Approval", onTap: (){
                                miscController.navigateTo(context: context,page: LeaveEntryPage());
                              },),
                            ),
                          ),
                        ],
                      ),
          ),
),
    );
  }
}