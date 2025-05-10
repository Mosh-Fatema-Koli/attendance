import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pinput/pinput.dart';

import '../../../api_service/colors.dart';
import '../../../common_controller/MiscController.dart';
import '../../widgets/framework/rf_loading_page.dart';
import '../../widgets/framework/rf_text.dart';
import '../Login/login_page.dart';
import 'cubit/forge_pass_cubit.dart';
import 'cubit/otp_cubit.dart';
import 'enter_newpass.dart';

class OtpPage extends StatelessWidget {
  final String email;
  final TextEditingController pinController = TextEditingController();
  final MiscController _miscController = MiscController();

  OtpPage({super.key, required this.email});

  static final defaultPinTheme = PinTheme(
    width: 56.w,
    height: 56.w,
    textStyle: TextStyle(
      fontSize: 20.sp,
      color: const Color.fromRGBO(30, 60, 87, 1),
      fontWeight: FontWeight.w600,
    ),
    decoration: BoxDecoration(
      border: Border.all(color: AppColors.primaryColor),
      borderRadius: BorderRadius.circular(20).w,
    ),
  );

  final focusedPinTheme = defaultPinTheme.copyDecorationWith(
    border: Border.all(color: AppColors.primaryColor),
    borderRadius: BorderRadius.circular(8).w,
  );

  final submittedPinTheme = defaultPinTheme.copyDecorationWith(
    color: AppColors.primaryColor,
  );

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
          ),
        ),
        child: MultiBlocProvider(
          providers: [
            BlocProvider(create: (BuildContext context) => OtpCubit()),
            BlocProvider(create: (BuildContext context) => ForgePassCubit())
          ],
          child: BlocConsumer<OtpCubit, OtpState>(
            listener: (context, state) {
              if (state is OtpInitial) {
                if (state.success) {
                  _miscController.navigateTo(
                    context: context,
                    page: EnterNewpass(email: email),
                  );
                } else if (state.message.isNotEmpty) {
                  dialog(
                    context: context,
                    success: state.success,
                    message: state.message,
                  );
                }
              }
            },
            builder: (context, state) {
                return Scaffold(
                  backgroundColor: Colors.transparent,
                  body: Center(
                    child: Padding(
                      padding: EdgeInsets.all(20).w,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RFText(
                            text: "OTP Verify",
                            size: 25.sp,
                            weight: FontWeight.bold,
                            color: AppColors.save_black,
                          ),
                          SizedBox(height: 10.h),
                          Row(
                            children: [
                              RFText(
                                text: "Please enter your OTP",
                                size: 12.sp,
                                weight: FontWeight.normal,
                                color: AppColors.save_black,
                              ),
                              SizedBox(width: 10,),
                              BlocBuilder<ForgePassCubit, ForgePassState>(
                            builder: (context, state) {
                              return GestureDetector(
                                onTap: () {
                                  context.read<ForgePassCubit>().sentEmail(context: context, email: email, onComplete: (isSuccess, message) {

                                  },);
                                },
                                child: RFText(
                                  text: "Resend OTP",
                                  size: 12.sp,
                                  weight: FontWeight.normal,
                                  color: AppColors.primaryColor,
                                ),
                              );
        },
      ),
                            ],
                          ),
                          SizedBox(height: 20.h),
                          Pinput(
                            length: 6,
                            controller: pinController,
                            defaultPinTheme: defaultPinTheme,
                            focusedPinTheme: focusedPinTheme,
                            submittedPinTheme: submittedPinTheme,
                            pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                            showCursor: true,
                            obscureText: true,
                          ),
                          SizedBox(height: 30.h),
                          GestureDetector(
                            onTap: () {
                              final otp = pinController.text.trim();
                              if (otp.isNotEmpty && otp.length == 6) {
                                context.read<OtpCubit>().varifyOTP(
                                  context: context,
                                  email: email,
                                  otp: otp,
                                  onComplete: (isSuccess, message) {
                                    if (isSuccess) {
                                      _miscController.navigateTo(
                                        context: context,
                                        page: EnterNewpass(email: email),
                                      );
                                      _miscController.toast(
                                          msg: message,
                                          position: ToastGravity.BOTTOM);
                                    }
                                  },
                                );
                              } else {
                                _miscController.toast(
                                    msg: "Please enter a valid 6-digit OTP.");
                              }
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width / 2.5,
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    AppColors.primaryColor,
                                    AppColors.primaryColor,
                                  ],
                                ),
                              ),
                              child: const Center(
                                child: Text(
                                  "Send OTP",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
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

  // Dialog for error/success
  Future<void> dialog({
    required BuildContext context,
    required bool success,
    required String message,
  }) async {
    await _miscController.showGraphicalDialog(
      context: context,
      cancelable: false,
      imagePath:
      success ? 'assets/images/check.png' : 'assets/images/no.png',
      title: 'Attention Please',
      subTitle: message,
      okText: 'OKAY',
      okPressed: () {
        Navigator.pop(context);
      },
    );
  }
}
