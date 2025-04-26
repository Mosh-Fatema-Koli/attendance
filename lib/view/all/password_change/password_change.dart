import 'package:attendance/view/all/Login/login_page.dart';
import 'package:attendance/view/widgets/framework/rf_button.dart';
import 'package:attendance/view/widgets/framework/rf_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../api_service/colors.dart';
import '../../../common_controller/MiscController.dart';
import '../Login/cubit/logout.dart';
import 'cubit/password_change_cubit.dart';

class PasswordChange extends StatelessWidget {
  PasswordChange({super.key});
  final miscController = MiscController();
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final logoutController = Logout();

  void _showMessage(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Password Change",),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }


  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
  }) {
    return Card(
      child: TextField(
        controller: controller,
        obscureText: true,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

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
            //backgroundColor: AppColors.appbarColor.withOpacity(.7),
            title: RFText(text: 'Change Password',weight:FontWeight.bold,color: Colors.black,size: 18.sp,)),
        body: BlocProvider(
        create: (context) => PasswordChangeCubit(),
        child: BlocConsumer<PasswordChangeCubit, PasswordChangeState>(
        listener: (context, state) {
      // TODO: implement listener
        },
        builder: (context, state) {
      return Center(
          child: Padding(
            padding: const EdgeInsets.all(20).w,
            child: SizedBox(
              height: MediaQuery.of(context).size.height/2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20,).w,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RFText(text: "Create New Password",size: 20.sp,weight: FontWeight.bold,),
                    SizedBox(height: 16.h),
                    _buildPasswordField(label: "Old Password", controller: oldPasswordController),
                     SizedBox(height: 16.h),
                    _buildPasswordField(label: "New Password", controller: newPasswordController),
                    const SizedBox(height: 16),
                    _buildPasswordField(label: "Confirm Password", controller: confirmPasswordController),
                    const SizedBox(height: 24),
                    GestureDetector(
                      onTap: () {
                        if (oldPasswordController.text.isEmpty ||
                            newPasswordController.text.isEmpty ||
                            confirmPasswordController.text.isEmpty) {
                          _showMessage(context, "All fields are required.");
                          return;
                        }

                        if (newPasswordController.text.length < 6) {
                          _showMessage(context, "New password must be at least 6 characters.");
                          return;
                        }

                        if (newPasswordController.text != confirmPasswordController.text) {
                          _showMessage(context, "New and Confirm Passwords do not match.");
                          return;
                        }
                        context.read<PasswordChangeCubit>().submitData(context: context,confirmPass: confirmPasswordController.text,newPass: newPasswordController.text,oldPass: oldPasswordController.text,
                            onComplete: (isSuccess, message,) async {
                              final _miscController = MiscController();
                              if(isSuccess){
                                _miscController.toast(msg: message);
                                await  logoutController.finalLogOut( onOut:(){
                                  _miscController.navigateTo(context: context, page: LoginPage());
                                }, context: context);
                              }else{
                                _miscController.toast(msg: message);
                              }
                            });

                      },
                      child: Padding(
                        padding: const EdgeInsets.only( top: 20).w,
                        child: Container(
                          width: MediaQuery.of(context).size.width/2.w,
                          padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20).w,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10).r,
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  AppColors.primaryColor,
                                  AppColors.primaryColor,
                                ],
                              )),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Reset Password",
                                style: TextStyle(
                                    color: Colors.white, fontWeight: FontWeight.w600,fontSize: 16.sp),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ),
          ),
        );
        },
      ),
      ),
      ),
    );
  }
}
