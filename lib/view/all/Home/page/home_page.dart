import 'package:attendance/common_controller/MiscController.dart';
import 'package:attendance/view/all/Home/comphonent/card.dart';
import 'package:attendance/view/widgets/framework/rf_loading_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../api_service/colors.dart';
import '../../../widgets/framework/C_button.dart';
import '../../../widgets/framework/RF_AppBar.dart';
import '../../../widgets/framework/rf_button.dart';
import '../../../widgets/framework/rf_text.dart';
import '../../Attendance/page/attendence_summary.dart';
import '../../Login/cubit/logout.dart';
import '../../Login/login_page.dart';
import '../cubit/dashbord/dashboard_cubit.dart';

class Homepage extends StatelessWidget {
   Homepage({super.key});
  @override
  Widget build(BuildContext context) {
    String formatTimeTo12Hour(String time24) {
      try {
        final time = DateFormat("HH:mm:ss").parse(time24); // or "HH:mm" if no seconds
        return DateFormat("hh:mm a").format(time); // e.g., 02:15 PM
      } catch (e) {
        return "--:-- AM";
      }
    }
    final miscController = MiscController();
    String month = "";
    String year = "";
    var date = DateTime.now(); // Current date-time
    String formattedDate = DateFormat('EEEE, dd MMM yyyy').format(date);

    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(80.w), child: RFAppBar()),
      body: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => DashboardCubit()..loadData()),
        ],
        child: BlocConsumer<DashboardCubit, DashboardState>(
          listener: (context, state) {
         // state.success==false?  logoutController.finalLogOut(context: context, onOut: (){
         //   miscController.navigateTo(context:context,page:  LoginPage());
         // }):null;
          },
          builder: (context, state) {
            return Stack(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                ),
                Container(
                  height: 80.h,
                  color: AppColors.primaryColor,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: AppColors.bodyColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50).r,
                      topRight: Radius.circular(50).r,
                    ),
                    // border: Border.all(color: AppColors.save_black),

                  ),
                  child: Padding(
                    padding:  EdgeInsets.symmetric(
                      horizontal: 20.w,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 20.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RFText(
                              text: "Overview",
                              size: 20.sp,
                              weight: FontWeight.bold,
                            ),
                            Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20)),
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                child: RFText(text: formattedDate))
                          ],
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Expanded(
                          child: state is DashboardLoadedState
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Card(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  10).r,
                                                          topRight:
                                                              Radius.circular(
                                                                  10).r,
                                                        ),
                                                      ),
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 10).w,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Icon(Icons
                                                                      .arrow_circle_right,size: 15.w,),

                                                                  RFText(
                                                                      text:
                                                                          " Check In"),
                                                                ],
                                                              ),
                                                              IconButton(
                                                                  onPressed:
                                                                      () {},
                                                                  icon: Icon(Icons
                                                                      .more_vert_rounded))
                                                            ],
                                                          ),
                                                        ],
                                                      )),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0).w,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: [
                                                        RFText(
                                                          text: state.dashboard.checkIn != null
                                                              ? formatTimeTo12Hour(state.dashboard.checkIn!)
                                                              : "--:-- AM",
                                                        ),
                                                        Container(
                                                          height: 10,
                                                          width: 2,
                                                          color: Colors.black,
                                                        ),
                                                        Container(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    vertical: 5,
                                                                    horizontal:
                                                                        10).w,
                                                            decoration: BoxDecoration(
                                                                color: AppColors
                                                                    .primaryColor,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20).r),
                                                            child: RFText(
                                                              text:   state.dashboard
                                                              .checkInstatus??"N/A",
                                                              color:
                                                                  Colors.white,
                                                            ))
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0).w,
                                                    child: RFText(
                                                      text: state.dashboard
                                                                  .checkIn !=
                                                              null
                                                          ? "Check In Success"
                                                          : "Do Check in",
                                                      textAlign:
                                                          TextAlign.start,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Card(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  10).r,
                                                          topRight:
                                                              Radius.circular(
                                                                  10).w,
                                                        ),
                                                      ),
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 10).w,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Icon(Icons
                                                                      .arrow_circle_left,size: 15.w,),

                                                                  RFText(
                                                                      text:
                                                                          " Check Out"),
                                                                ],
                                                              ),
                                                              IconButton(
                                                                  onPressed:
                                                                      () {},
                                                                  icon: Icon(Icons
                                                                      .more_vert_rounded))
                                                            ],
                                                          ),
                                                        ],
                                                      )),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0).w,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: [
                                                        RFText(
                                                          text: state.dashboard.checkOut != null
                                                              ?formatTimeTo12Hour(state.dashboard.checkOut!)
                                                              : "--:-- PM",
                                                        ),
                                                        Container(
                                                          height: 10,
                                                          width: 2,
                                                          color: Colors.black,
                                                        ),
                                                        Container(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    vertical: 5,
                                                                    horizontal:
                                                                        10).w,
                                                            decoration: BoxDecoration(
                                                                color: AppColors
                                                                    .primaryColor,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20).r),
                                                            child: RFText(
                                                              text: state.dashboard
                                                                  .checkOutstatus??"N/A",
                                                              color:
                                                                  Colors.white,
                                                            ))
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0).w,
                                                    child: RFText(
                                                      text: state.dashboard
                                                                  .checkIn !=
                                                              null
                                                          ? "Complete"
                                                          : "Its incomplete",
                                                      textAlign:
                                                          TextAlign.start,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 15.h,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Card(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  10).w,
                                                          topRight:
                                                              Radius.circular(
                                                                  10).w,
                                                        ),
                                                      ),
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 8).w,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Icon(Icons
                                                                      .watch_later,size: 15.w,),

                                                                  RFText(
                                                                      text:
                                                                          " Break"),
                                                                ],
                                                              ),
                                                              IconButton(
                                                                  onPressed:
                                                                      () {},
                                                                  icon: Icon(Icons
                                                                      .more_vert_rounded))
                                                            ],
                                                          ),
                                                        ],
                                                      )),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0).w,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: [
                                                        RFText(
                                                            text: "01 Hour"),
                                                        Container(
                                                          height: 10.h,
                                                          width: 2.w,
                                                          color: Colors.black,
                                                        ),
                                                        Container(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    vertical: 5,
                                                                    horizontal:
                                                                        10).w,
                                                            decoration: BoxDecoration(
                                                                color: AppColors
                                                                    .primaryColor,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20).r),
                                                            child: RFText(
                                                              text: "Every day",
                                                              color:
                                                                  Colors.white,
                                                            ))
                                                      ],
                                                    ),
                                                  ),
                                                  // Padding(
                                                  //   padding:
                                                  //       const EdgeInsets.all(
                                                  //           8.0),
                                                  //   child: RFText(
                                                  //     text: "Break ongoing",
                                                  //     textAlign:
                                                  //         TextAlign.start,
                                                  //   ),
                                                  // ),
                                                  SizedBox(height: 10.h,)
                                                ],
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Card(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  10).r,
                                                          topRight:
                                                              Radius.circular(
                                                                  10).r,
                                                        ),
                                                      ),
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 8).w,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Icon(Icons
                                                                      .work_history_outlined,size: 15.w,),

                                                                  RFText(
                                                                      text:
                                                                          " Working time",),
                                                                ],
                                                              ),
                                                              IconButton(
                                                                  onPressed:
                                                                      () {},
                                                                  icon: Icon(Icons
                                                                      .more_vert_rounded))
                                                            ],
                                                          ),
                                                        ],
                                                      )),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0).w,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: [
                                                        RFText(
                                                            text:
                                                                "Total"),
                                                        Container(
                                                          height: 10.h,
                                                          width: 2.w,
                                                          color: Colors.black,
                                                        ),
                                                        Container(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    vertical: 5,
                                                                    horizontal:
                                                                        10).w,
                                                            decoration: BoxDecoration(
                                                                border: Border.all(color:AppColors.primaryColor,width: 2,style: BorderStyle.solid),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20).r),
                                                            child: RFText(
                                                              text: "${state.dashboard.totalWorkingHours ?? 00} Hours",
                                                              color:
                                                                  Colors.black,
                                                            ))
                                                      ],
                                                    ),
                                                  ),
                                                  // Padding(
                                                  //   padding:
                                                  //       const EdgeInsets.all(
                                                  //           8.0),
                                                  //   child: RFText(
                                                  //     text: "Its good",
                                                  //     textAlign:
                                                  //         TextAlign.start,
                                                  //   ),
                                                  // ),
                                                  SizedBox(height: 10.h,)
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20.h,
                                      ),
                                      prestenHistory(context, month, year, miscController, state)
                                    ])
                              : Opacity(
                                  opacity: 0.7, // Adjust transparency
                                  child: Center(
                                    child: RfLoadingPage(),
                                  ),
                                ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }

  Expanded prestenHistory(BuildContext context, String month, String year, MiscController miscController, DashboardLoadedState state) {
    return Expanded(
                                        child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            RFText(
                                              text: "Presences History",
                                              size: 16.sp,
                                              weight: FontWeight.bold,
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                String? selectedMonth;
                                                String? selectedYear;

                                                List<String> months = [
                                                  "January",
                                                  "February",
                                                  "March",
                                                  "April",
                                                  "May",
                                                  "June",
                                                  "July",
                                                  "August",
                                                  "September",
                                                  "October",
                                                  "November",
                                                  "December"
                                                ];
                                                List<String> years =
                                                    List.generate(
                                                        10,
                                                        (index) => (DateTime
                                                                        .now()
                                                                    .year -
                                                                index)
                                                            .toString());

                                                showDialog(
                                                  context: context,
                                                  barrierDismissible: true,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      contentPadding:
                                                          EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      16),
                                                      content: Container(
                                                        height: 300.w,
                                                        width: 250.w,
                                                        child: Stack(
                                                          children: [
                                                            Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                    "Choose Option",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            16.sp,
                                                                        fontWeight:
                                                                            FontWeight.bold)),
                                                                SizedBox(
                                                                    height:
                                                                        20.h),
                                                                DropdownButtonFormField<
                                                                    String>(
                                                                  value:
                                                                      selectedMonth,
                                                                  decoration: InputDecoration(
                                                                      labelText:
                                                                          "Select Month"),
                                                                  items: months
                                                                      .map((String
                                                                          month) {
                                                                    return DropdownMenuItem<
                                                                        String>(
                                                                      value:
                                                                          month,
                                                                      child: Text(
                                                                          month),
                                                                    );
                                                                  }).toList(),
                                                                  onChanged:
                                                                      (String?
                                                                          newValue) {
                                                                    selectedMonth =
                                                                        newValue;
                                                                    month = newValue
                                                                        .toString();
                                                                  },
                                                                ),
                                                                SizedBox(
                                                                    height:
                                                                        10.h),
                                                                DropdownButtonFormField<
                                                                    String>(
                                                                  value:
                                                                      selectedYear,
                                                                  decoration: InputDecoration(
                                                                      labelText:
                                                                          "Select Year"),
                                                                  items: years
                                                                      .map((String
                                                                          year) {
                                                                    return DropdownMenuItem<
                                                                        String>(
                                                                      value:
                                                                          year,
                                                                      child: Text(
                                                                          year),
                                                                    );
                                                                  }).toList(),
                                                                  onChanged:
                                                                      (String?
                                                                          newValue) {
                                                                    selectedYear =
                                                                        newValue;
                                                                    year = newValue
                                                                        .toString();
                                                                  },
                                                                ),
                                                                SizedBox(
                                                                    height:
                                                                        20),
                                                                CButton(
                                                                    buttonText:
                                                                        "Send",
                                                                    onTap:
                                                                        () {
                                                                      if (year.isNotEmpty &&
                                                                          month.isNotEmpty) {
                                                                        miscController.navigateTo(
                                                                            context: context,
                                                                            page: AttendanceSummary(
                                                                              month: month,
                                                                              year: year,
                                                                            ));
                                                                        year =
                                                                            "";
                                                                        month =
                                                                            "";
                                                                      } else {
                                                                        miscController.toast(
                                                                            msg: "Please select correct date and month");
                                                                      }
                                                                    })
                                                              ],
                                                            ),
                                                            Positioned(
                                                              right: -10,
                                                              top: 0,
                                                              child:
                                                                  IconButton(
                                                                onPressed: () =>
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop(),
                                                                icon: Icon(
                                                                    Icons
                                                                        .cancel,
                                                                    color: Colors
                                                                        .red),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                );
                                              },
                                              child: Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius
                                                              .circular(20).r),
                                                  padding:
                                                      EdgeInsets.symmetric(
                                                              vertical: 10,
                                                              horizontal: 20)
                                                          .w,
                                                  child: Row(
                                                    children: [
                                                      RFText(
                                                          text:
                                                              "Search Month & Year"),
                                                      SizedBox(
                                                        width: 5.w,
                                                      ),
                                                      Icon(
                                                        Icons.arrow_drop_down,
                                                        color: AppColors
                                                            .primaryColor,
                                                      )
                                                    ],
                                                  )),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 15.h,
                                        ),
                                        Expanded(
                                          child: state.dashboard
                                                      .currentMonthAttendance !=
                                                  null
                                              ? ListView.builder(
                                                  padding: EdgeInsets.zero,
                                                  shrinkWrap: true,
                                                  physics:
                                                      AlwaysScrollableScrollPhysics(),
                                                  itemCount: state
                                                      .dashboard!
                                                      .currentMonthAttendance!
                                                      .length,
                                                  itemBuilder:
                                                      (context, index) =>
                                                          Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                            vertical: 2).w
                                                        .w,
                                                    child: CardList(
                                                      attendanceHistory: state
                                                              .dashboard!
                                                              .currentMonthAttendance![
                                                          index],
                                                    ),
                                                  ),
                                                )
                                              : _buildEmptyState(),
                                        ),
                                      ],
                                    ));
  }

  Widget _buildEmptyState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 32.h),
        Image.asset(
          'assets/images/empty.png',
          color: AppColors.primaryColor,
          fit: BoxFit.fitHeight,
          height: 30.h,
        ),
        SizedBox(height: 16.h),
        RFText(
          text: 'No data found!',
          weight: FontWeight.w500,
          size: 16.sp,
          color: Colors.black87.withOpacity(0.8),
        ),
        SizedBox(height: 32.h),
      ],
    );
  }

}
