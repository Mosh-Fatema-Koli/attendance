import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

import '../../../../api_service/ApiController.dart';
import '../../../../common_controller/MiscController.dart';

part 'otp_state.dart';

class OtpCubit extends Cubit<OtpState> {

  OtpCubit() : super(OtpInitial());
  API api = API();

  final _miscController = MiscController();

  varifyOTP({
    required BuildContext context,
    required String email,
    required String otp,
    required Function(bool isSuccess, String message) onComplete,
  }) async {
    _miscController.showProgressDialog(context: context);
    await _miscController.checkInternet().then((value) async {
      if (!value.contains('ignore')) {
        try {
          // Prepare FormData
          FormData formData = FormData.fromMap({
            "email":email,
            "otp":otp
          });

          // Send API Request
          var apiResponse = await api.postData(
            endpoint: "/verify-otp/",
            data: formData, // Pass FormData directly
          );

          var response = jsonDecode(apiResponse);
          var success = response['Success'];
          var message = response['Message'];
          _miscController.navigateBack(context: context);
          if (success) {
            onComplete(true, "OTP matched. Please create your new password");
            emit(OtpLoadedState(success: true, message: "OTP matched. Please create your new password"));
          } else {
            onComplete(false, "Something went wrong");
            emit(OtpLoadedState(success: false, message: "Something went wrong"));
          }
        } catch (e) {
          onComplete(false, "Something went wrong");
          print(" Error: $e");
        }
      } else {
        emit(OtpLoadedState(success: false, message: "Something went wrong"));
      }
    });
  }
}
