import 'package:attendance/view/all/nab_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../../api_service/colors.dart';
import '../../../common_controller/MiscController.dart';
import '../../widgets/framework/rf_button.dart';
import '../../widgets/framework/rf_text.dart';
import '../forget_pass/enter_email.dart';
import 'cubit/login_cubit.dart';
import 'cubit/login_state.dart';


class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  final MiscController _miscController = MiscController();
  @override
  Widget build(BuildContext context) {

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, Object? result) async {
        if (didPop) {
          return;
        }
        await _miscController.showAppExitDialog(context: context);
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
        child: BlocProvider(
          create: (context) => LoginCubit(),
          child: BlocConsumer<LoginCubit, LoginState>(
            listener: (context, state) {
              // TODO: implement listener
            },
            builder: (context, state) {
              var cubit = LoginCubit.get(context);
              //  cubit.emailController.text="EID-381653";
              // cubit.passwordController.text="1234567";
              return MultiBlocProvider(
                  providers: [
                    BlocProvider(create: (BuildContext context) => LoginCubit())
                  ],
                  child: BlocConsumer<LoginCubit, LoginState>(
                    listener: (context, state) {
                          if (state is LoginInitial) {
                            if(state.success){
                              _miscController.navigateTo(context: context, page: NavbarPage(initialIndex: 0));
                            } else {
                              if(state.message.isNotEmpty){
                                dialog(context: context, success: state.success, message: state.message);
                              }
                            }
                          }
                    },
                    builder: (context, state) {
                      if(state is LoginInitial){
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
                                    text: "Log In",
                                    size: 25.sp,
                                    weight: FontWeight.bold,
                                    color: AppColors.save_black,
                                  ),
                                  SizedBox(height: 10,)
                                  ,RFText(
                                    text: "Don’t have an account? Please contact with your admin",
                                    size: 12.sp,
                                    weight: FontWeight.normal,
                                    color: AppColors.save_black,
                                  ),

                                  SizedBox(
                                    height: 20.h,
                                  ),
                                  TextFormField(
                                    controller: cubit.emailController,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter some text';
                                      }
                                      return null;
                                    },
                                    decoration: const InputDecoration(
                                      hintText: 'Enter your User name',
                                      prefixIcon: Icon(Icons.person_2_outlined),
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
                                    height: 20.w,
                                  ),
                                  Stack(
                                    children: [
                                      TextFormField(
                                        controller: cubit.passwordController,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter some text';
                                          }
                                          if (value.length < 5) {
                                            return 'Password must be at least 5 characters';
                                          }
                                          return null;
                                        },
                                        obscureText: !state.isPasswordVisible,
                                        decoration: InputDecoration(
                                            floatingLabelStyle: TextStyle(color: AppColors.primaryColor),
                                            hintText: 'password',
                                            prefixIcon: const Icon(Icons.lock_outline_rounded),
                                            border: const OutlineInputBorder(
                                              borderRadius: BorderRadius.all(Radius.circular(15),),
                                              borderSide: BorderSide(color: AppColors.save_black)
                                            ),
                                            focusedBorder: const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(15),)
                            ),

                                            // suffixIcon: IconButton(
                                            //   icon: Icon(state.isPasswordVisible
                                            //       ? Icons.visibility_off
                                            //       : Icons.visibility),
                                            //   onPressed: () {
                                            //     context.read<LoginCubit>().updatePasswordVisibility(isVisible: state.isPasswordVisible ? false : true);
                                            //   },
                                            // )
                                        ),
                                      ),
                                      Positioned(
                                        right: 20.h,
                                        top: 17.w,
                                        child: GestureDetector(
                                          onTap: () {
                                            _miscController.navigateTo(context: context, page: EnterEmailPage());
                                          },
                                          child: RFText(
                                            text: "Forgot",
                                            textAlign: TextAlign.end,
                                            size: 14.sp,
                                            color: AppColors.primaryColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20.h,
                                  ),

                                  GestureDetector(
                                    onTap: () {
                                      if (cubit.emailController.text.isNotEmpty && cubit.passwordController.text.isNotEmpty) {
                                        context.read<LoginCubit>().loginApiCall(context: context, isPasswordVisible: state.isPasswordVisible, username: cubit.emailController.text, password: cubit.passwordController.text);
                                      } else {
                                        _miscController.toast(msg: 'Please enter valid username and password');
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
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.login,
                                              color: Colors.white,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              "LOG IN",
                                              style: TextStyle(
                                                  color: Colors.white, fontWeight: FontWeight.w600),
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
                        );
                      } else {
                        return loading();
                      }

                    },
                  ));
            },
          ),
        ),
      ),
    );
  }

  Widget loading(){
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SpinKitCircle(
            color: AppColors.primaryColor,
            size: 72.0.w,
          ),
          SizedBox(height: 16.h),
          RFText(text: 'Please Wait...', weight: FontWeight.w500, size: 15.sp, color: Colors.black87.withOpacity(0.8)),
        ],
      ),
    );
  }
  //endregion

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
