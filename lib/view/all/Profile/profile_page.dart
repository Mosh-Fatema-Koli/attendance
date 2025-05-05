import 'package:attendance/api_service/app_cash.dart';
import 'package:attendance/view/all/update_profile/update_profile.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../api_service/Constant.dart';
import '../../../common_controller/MiscController.dart';
import '../../../api_service/colors.dart';
import '../../widgets/framework/rf_button.dart';
import '../../widgets/framework/rf_text.dart';
import '../Attendance/page/attendance_history.dart';
import '../Leave/history/leave_history.dart';
import '../Login/cubit/logout.dart';
import '../Onboard/SplashPage.dart';
import '../WFH/history/history.dart';
import '../password_change/password_change.dart';


class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  MiscController miscController = MiscController();
  final logoutController = Logout();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Container(
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

              ],
            )),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Container(
                  height: 120.h,
                  width: 120.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryColor,
                  ),
                  padding: EdgeInsets.all(5).w,
                  child: ClipOval( // Use ClipOval for a perfect circle
                    child: CachedNetworkImage(
                      imageUrl: "${Constant.imageUrl}${AppCache().userInfo!.image}",
                      fit: BoxFit.cover, // Cover to fill the circular space
                      placeholder: (context, url) => Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, error) =>
                          Image.asset("assets/images/man.png", fit: BoxFit.cover),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                RFText(
                  text: AppCache().userInfo?.name ?? "Not Found",
                  weight: FontWeight.bold,
                  size: 18.sp,
                ),
                RFText(
                    text: AppCache().userInfo?.email ??
                        "Not Found"),
                RFText(
                    text: AppCache().userInfo?.phone ??
                        "Not Found"),
                SizedBox(
                  height: 30.h,
                ),
                Padding(padding: EdgeInsets.symmetric(horizontal: 20,vertical: 5).w,
                  child:  Card(
                    color: Colors.white,
                    elevation: 5,
                    child: ListTile(

                      onTap: () {
                        miscController.navigateTo(context: context,page: UpdateProfile(userInfo: AppCache().userInfo!,));
                      },
                      leading: Icon(Icons.person),
                      title: RFText(text: "Update Profile"),
                      trailing: Icon(Icons.arrow_forward_ios,size: 20,),
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.symmetric(horizontal: 20,vertical: 5).w,
                  child:  Card(
                    color: Colors.white,
                    elevation: 5,
                    child: ListTile(
                      onTap: () {
                          miscController.showCustomWidgetDialog(
                              context: context,
                              leftPadding: 16,
                              rightPadding: 16,
                              cancelable: true,
                              dialogContent:Container(
                                height: 200,
                                width: 200,
                                child: Stack(
                                  children: [
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text("Choice An Option"),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        RFButton(text: "Leave", onPressed: (){
                                          miscController.navigateBack( context: context);
                                          miscController.navigateTo(context: context,page: LeaveHistoryPage());

                                        },buttonColor: AppColors.primaryColor,),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        RFButton(text: "Work From Home", onPressed: (){
                                          miscController.navigateBack( context: context);
                                          miscController.navigateTo(context: context,page: WFHPage());

                                        },buttonColor: Colors.white,borderColor: AppColors.primaryColor,textColor: AppColors.primaryColor,),
                                      ],
                                    ),
                                    Positioned(
                                        right: -15,

                                        child:IconButton(onPressed: () {
                                          miscController.navigateBack( context: context);
                                        }, icon:  Icon(Icons.cancel,color: AppColors.primaryColor,)))
                                  ],
                                ),
                              ));
                        },

                      leading: Icon(Icons.calendar_month),
                      title: RFText(text: "Leave/ WFH"),
                      trailing: Icon(Icons.arrow_forward_ios,size: 20,),
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.symmetric(horizontal: 20,vertical: 5).w,
                  child:  Card(
                    color: Colors.white,
                    elevation: 5,
                    child: ListTile(
                      onTap: () {
                        miscController.navigateTo(context: context,page: HistoryPage());
                      },
                      leading: Icon(Icons.insert_chart),
                      title: RFText(text: "Working Summary"),
                      trailing: Icon(Icons.arrow_forward_ios,size: 20,),
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.symmetric(horizontal: 20,vertical: 5).w,
                  child:  Card(
                    color: Colors.white,
                    elevation: 5,
                    child: ListTile(
                      onTap: () {
                        miscController.navigateTo(context: context,page: PasswordChange());
                      },
                      leading: Icon(Icons.password),
                      title: RFText(text: "Change Password"),
                      trailing: Icon(Icons.arrow_forward_ios,size: 20,),
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.symmetric(horizontal: 20,vertical: 5).w,
                  child:  Card(
                    color: Colors.white,
                    elevation: 5,
                    child: ListTile(
                      onTap: () {
                        logoutController.logout(context: context, onLogout: (){
                          miscController.navigateTo(context: context, page: SplashPage());
                        });
                      },
                      leading: Icon(Icons.logout),
                      title: RFText(text: "Sign-Out"),
                      trailing: Icon(Icons.arrow_forward_ios,size: 20,),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}