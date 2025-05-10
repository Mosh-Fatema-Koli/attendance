import 'package:attendance/view/all/Login/login_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../api_service/colors.dart';
import '../../../common_controller/MiscController.dart';
import '../../widgets/framework/rf_loading_page.dart';
import '../../widgets/framework/rf_text.dart';
import 'cubit/crearte_new_pass_cubit.dart';
import 'cubit/forge_pass_cubit.dart';
import 'otp.dart';

class EnterNewpass extends StatelessWidget {
  String email;
  EnterNewpass({super.key,required this.email});

   TextEditingController newPass=TextEditingController();
   TextEditingController confirmPass=TextEditingController();
   final MiscController _miscController = MiscController();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, Object? result) async {
        if (didPop) {
          return;
        }
        await _miscController.showAlertDialog(context: context, cancelable: false,title: "Close session",subTitle: "Do you want to close this session?",
            okPressed:(){
          _miscController.navigateTo(context: context,page: LoginPage());
            },okText: "Yes" ,cancelPressed:(){
          _miscController.navigateBack(context: context);
            },cancelText: "No");
      },
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
                  AppColors.bodyColor,


                ],
              )),
          child:  MultiBlocProvider(
              providers: [
                BlocProvider(create: (BuildContext context) => CreateNewPassCubit())
              ],
              child: BlocConsumer<CreateNewPassCubit, CrearteNewPassState>(
                listener: (context, state) {
                  if (state is CreateNewPassInitial) {
                    if(state.success){
                      _miscController.navigateTo(context: context, page: LoginPage());
                    } else {
                      if(state.message.isNotEmpty){
                        dialog(context: context, success: state.success, message: state.message);
                      }
                    }
                  }
                },
                builder: (context, state) {
                    return Scaffold(
                      backgroundColor: Colors.transparent,
                      body: Center(
                        child: Padding(
                          padding: EdgeInsets.all(30).w,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RFText(
                                text: "Create New Password",
                                size: 25.sp,
                                weight: FontWeight.bold,
                                color: AppColors.save_black,
                              ),
                              SizedBox(height: 10,)
                              ,RFText(
                                text: " Please enter your new password",
                                size: 12.sp,
                                weight: FontWeight.normal,
                                color: AppColors.save_black,
                              ),

                              SizedBox(
                                height: 20.h,
                              ),
                              TextFormField(
                                controller: newPass,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter some text';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  hintText: ' new password',
                                  prefixIcon: Icon(Icons.password),
                                  border: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(15),),
                                      borderSide: BorderSide(color: AppColors.save_black)
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(15),)
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              TextFormField(
                                controller: confirmPass,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter some text';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  hintText: 'confirm password',
                                  prefixIcon: Icon(Icons.password),
                                  border: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(15),),
                                      borderSide: BorderSide(color: AppColors.save_black)
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(15),)
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20.h,
                              ),

                              GestureDetector(
                                onTap: () {
                                  if (newPass.text.isNotEmpty && confirmPass.text.isNotEmpty) {
                                    if (newPass.text == confirmPass.text) {
                                      final navContext = context; // Save current context for safe navigation

                                      context.read<CreateNewPassCubit>().createNew(
                                        context: context,
                                        email: email,
                                        newPass: newPass.text,
                                        confirmPass: confirmPass.text,
                                        onComplete: (isSuccess, message) {
                                          _miscController.toast(msg: message, position: ToastGravity.BOTTOM);
                                          if (isSuccess) {
                                            _miscController.navigateTo(context: navContext, page: LoginPage());
                                          }
                                        },
                                      );
                                    } else {
                                      _miscController.toast(msg: "Passwords do not match");
                                    }
                                  } else {
                                    _miscController.toast(msg: "Password fields cannot be empty");
                                  }

                                },
                                child: Padding(
                                  padding: const EdgeInsets.only( top: 20),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width/2.5,
                                    padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            AppColors.primaryColor,
                                            AppColors.primaryColor,
                                          ],
                                        )),
                                    child: Text(
                                      "Reset Password",
                                      style: TextStyle(
                                          color: Colors.white, fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                              ),

                            ],
                          ),
                        ),
                      ),
                    );
                  }
              ))
      ),
    );
  }
  //region dialog
  Future dialog({required BuildContext context, required bool success, required String message}) async {
    await _miscController.showGraphicalDialog(
        context: context,
        cancelable: false,
        imagePath: success ? 'assets/images/check.png' : 'assets/images/no.png',
        title: 'Attention Please',
        subTitle: message,
        okText: 'OKAY',
        okPressed: () {
          Navigator.pop(context);
        });
  }
//endregion
}
