import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../api_service/ApiController.dart';
import '../../../../api_service/Constant.dart';
import '../../../../api_service/app_cash.dart';
import '../../../../common_controller/MiscController.dart';
import '../../../../common_model/UserInfo.dart';
import '../otp.dart';

part 'forge_pass_state.dart';

class ForgePassCubit extends Cubit<ForgePassState> {
  ForgePassCubit() : super(ForgePassInitial());

  API api = API();
  final _miscController = MiscController();

  sentEmail({
    required BuildContext context,
    required String email,
    required Function(bool isSuccess, String message) onComplete,
  }) async {
    _miscController.showProgressDialog(context: context);

    await _miscController.checkInternet().then((value) async {
      if (!value.contains('ignore')) {
        try {
          // Prepare FormData
          FormData formData = FormData.fromMap({
            "email": email
          });

          // Send API Request
          var apiResponse = await api.postData(
            endpoint: "/send-forgot-otp/",
            data: formData, // Pass FormData directly
          );

          var response = jsonDecode(apiResponse);
          var success = response['Success'];
          var message = response['Message'];
          _miscController.navigateBack(context: context);
          if (success) {
            onComplete(true, "OTP has been sent to your email. Please check your mail");
            emit(ForgePassLoadedState(success: true, message: "OTP has been sent to your email. Please check your mail"));
          } else {
            emit(ForgePassLoadedState(success: false, message: "Something went wrong"));
          }
        } catch (e) {
          print(" Error: $e");
        }
      } else {
        emit(ForgePassLoadedState(success: false, message: "Something went wrong"));
      }
    });
  }



}
