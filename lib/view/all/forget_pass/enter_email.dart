import 'package:attendance/view/all/forget_pass/otp.dart';
import 'package:attendance/view/widgets/framework/rf_loading_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../api_service/colors.dart';
import '../../../common_controller/MiscController.dart';
import '../../widgets/framework/rf_text.dart';
import '../Login/login_page.dart';
import 'cubit/forge_pass_cubit.dart';

class EnterEmailPage extends StatelessWidget {
   EnterEmailPage({super.key});

   final MiscController _miscController = MiscController();
   TextEditingController email=TextEditingController();
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
              BlocProvider(create: (BuildContext context) => ForgePassCubit())
            ],
            child: BlocConsumer<ForgePassCubit, ForgePassState>(
              listener: (context, state) {
                if (state is ForgePassInitial) {
                  if(state.success){
                    _miscController.navigateTo(context: context, page: OtpPage(email: email.text,));
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
                              text: "Reset Password",
                              size: 25.sp,
                              weight: FontWeight.bold,
                              color: AppColors.save_black,
                            ),
                            SizedBox(height: 10,)
                            ,RFText(
                              text: "Forget password? Please enter your email",
                              size: 12.sp,
                              weight: FontWeight.normal,
                              color: AppColors.save_black,
                            ),

                            SizedBox(
                              height: 30.h,
                            ),
                            TextFormField(
                              controller: email,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter some text';
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                hintText: 'Enter your email',
                                prefixIcon: Icon(Icons.email),
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

                            GestureDetector(
                              onTap: () {

                                if (email.text.isNotEmpty) {
                                  context.read<ForgePassCubit>().sentEmail(context: context, email: email.text,
                                  onComplete: (isSuccess, message) {
                                    if (isSuccess) {
                                      _miscController.navigateTo(context: context, page: OtpPage(email: email.text));
                                      _miscController.toast(msg: message,position: ToastGravity.BOTTOM);
                                    }

                                  });

                                } else {
                                  _miscController.toast(msg: 'Please enter your email');
                                }

                              },
                              child: Padding(
                                padding: const EdgeInsets.only( top: 20),
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20).w,
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

              },
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
