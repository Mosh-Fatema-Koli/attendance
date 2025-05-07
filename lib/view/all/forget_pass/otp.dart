import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';

import '../../../api_service/colors.dart';
import '../../../common_controller/MiscController.dart';
import '../../widgets/framework/rf_loading_page.dart';
import '../../widgets/framework/rf_text.dart';
import 'cubit/forge_pass_cubit.dart';
import 'enter_newpass.dart';

class OtpPage extends StatelessWidget {
  String email;
   OtpPage({super.key,required this.email});

  TextEditingController pinController = TextEditingController();

  static final defaultPinTheme = PinTheme(
    width: 56.w,
    height: 56.w,
    textStyle:  TextStyle(fontSize: 20.sp,
        color: Color.fromRGBO(30, 60, 87, 1),
        fontWeight: FontWeight.w600),
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
      color:  AppColors.primaryColor

  );
   final MiscController _miscController = MiscController();
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
                AppColors.bodyColor,


              ],
            )),
        child:  MultiBlocProvider(
            providers: [
              BlocProvider(create: (BuildContext context) => ForgePassCubit())
            ],
            child: BlocConsumer<ForgePassCubit, ForgePassState>(
              listener: (context, state) {
                if (state is ForgePassInitial) {
                  if(state.success){
                    _miscController.navigateTo(context: context, page: EnterNewpass());
                  } else {
                    if(state.message.isNotEmpty){
                      dialog(context: context, success: state.success, message: state.message);
                    }
                  }
                }
              },
              builder: (context, state) {
                if(state is ForgePassInitial){
                  return Scaffold(
                    backgroundColor: Colors.transparent,
                    body: Center(
                      child: Padding(
                        padding: EdgeInsets.all(15).w,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RFText(
                              text: "OTP verify",
                              size: 25.sp,
                              weight: FontWeight.bold,
                              color: AppColors.save_black,
                            ),
                            SizedBox(height: 10,)
                            ,RFText(
                              text: " Please enter your OTP",
                              size: 12.sp,
                              weight: FontWeight.normal,
                              color: AppColors.save_black,
                            ),

                            SizedBox(
                              height: 20.h,
                            ),
                            Pinput(
                              defaultPinTheme: defaultPinTheme,
                              focusedPinTheme: focusedPinTheme,
                              submittedPinTheme: submittedPinTheme,
                              pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                              showCursor: true,
                              obscureText: true,
                              controller: pinController,
                              onCompleted: (pin) {
                              //  controller.checkPin(pin);
                              },
                            ),

                            SizedBox(
                              height: 20.h,
                            ),

                            GestureDetector(
                              onTap: () {
                                // if (cubit.emailController.text.isNotEmpty && cubit.passwordController.text.isNotEmpty) {
                                //   context.read<LoginCubit>().loginApiCall(context: context, isPasswordVisible: state.isPasswordVisible, username: cubit.emailController.text, password: cubit.passwordController.text);
                                // } else {
                                //   _miscController.toast(msg: 'Please enter valid username and password');
                                // }
                                _miscController.navigateTo(context: context,page: EnterNewpass());
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
                                    "Send OTP",
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
                } else {
                  return RfLoadingPage();
                }

              },
            ))
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


