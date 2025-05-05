import 'package:attendance/view/all/Attendance/cubit/history_filter/attendanceFilterCubit.dart';
import 'package:attendance/view/all/Home/cubit/dashbord/dashboard_cubit.dart';
import 'package:attendance/view/widgets/framework/rf_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../api_service/colors.dart';
import '../cubit/history/atteendance_history_cubit.dart';
import '../cubit/history_filter/atteendance_filter_state.dart';

Widget serviceSummaryList(BuildContext context) {
  return BlocBuilder<AttendanceFilterCubit, AttendanceFilterState>(
    builder: (context, state) {
      if (state is AttendanceFilterLoadedState) {
        final calculation = state.summary;
        final summaryList = state.summaryList;

        String formatHoursToHoursMinutes(double? decimalHours) {
          if (decimalHours == null) return "--";
          final hours = decimalHours.floor();
          final minutes = ((decimalHours - hours) * 60).round();
          return "$hours hr ${minutes} min";
        }

        final List<String> values = [
          "${calculation.totalPresent ?? 0} days",
          "${calculation.totalAbsent ?? 0} days",
          formatHoursToHoursMinutes(calculation.totalHours),
          "${calculation.totalLate ?? 0} days",
          "${calculation.totalEarly ?? 0} days",
          formatHoursToHoursMinutes(calculation.totalLessMoreHours),
        ];

        return GridView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 5.0.w,
            mainAxisSpacing: 5.0.h,
            childAspectRatio: 9 / 5.r,
          ),
          itemCount: summaryList.length,
          itemBuilder: (context, index) {
            final menu = summaryList[index];

            return Card(
              elevation: 4,
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.all(8.0.r),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    RFText(
                      text: index < values.length ? values[index] : "--",
                      color: Colors.black,
                      size: 12.sp,
                      weight: FontWeight.bold,
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      menu.name,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }
      return Center(child: Text("No Summary Data"));
    },
  );
}
