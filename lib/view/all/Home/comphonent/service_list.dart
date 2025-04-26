// import 'package:attendance/view/pages/Home/cubit/dashbord/dashboard_cubit.dart';
// import 'package:attendance/view/widgets/framework/rf_text.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import '../../../../api_service/colors.dart';
// import '../cubit/menu/home_cubit.dart';
//
//  serviceList(HomeCubit cubit, BuildContext context) {
//   return BlocProvider(
//     create: (context) => DashboardCubit()..loadData(),
//     child: BlocConsumer<DashboardCubit, DashboardState>(
//       listener: (context, state) {},
//       builder: (context, state) {
//         return Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 15).r,
//           child: GridView.builder(
//             padding: EdgeInsets.zero,
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 3,
//               crossAxisSpacing: 5.0.w,
//               mainAxisSpacing: 5.0.h,
//               childAspectRatio: 9 / 6.r,
//             ),
//             itemCount: cubit.menuList.length,
//             itemBuilder: (context, index) {
//               final menu = cubit.menuList[index];
//               final calculation = state.calculateAttendance;
//
//               // Using a list for better structure
//               final List<String> values = [
//                 "${calculation.totalPresent?? 0}",
//                 "${calculation.totalAbsent??0}",
//                 "${calculation.totalLateHours??0}",
//                 "${calculation.totalLate??0}",
//                 "${calculation.totalEarly??0}",
//                 "${calculation.totalEarly??0}",
//                 "${calculation.totalEarlyHours??0}",
//               ];
//
//               return Card(
//                 elevation: 5,
//                 color: Colors.white,
//                 child: Padding(
//                   padding: EdgeInsets.all(8.0.r),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       RFText(
//                         text: index < values.length ? values[index] : "--",
//                         color: Colors.black,
//                         size: 16,
//                         weight: FontWeight.bold,
//                       ),
//                       SizedBox(height: 5.h),
//                       Text(
//                         menu.name,
//                         style: TextStyle(
//                           fontSize: 12.sp,
//                           color: AppColors.primaryColor,
//                           fontWeight: FontWeight.bold,
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//         );
//       },
//     ),
//   );
// }
