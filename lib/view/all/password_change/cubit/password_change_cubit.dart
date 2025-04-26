import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import '../../../../api_service/ApiController.dart';
import '../../../../api_service/app_cash.dart';
import '../../../../common_controller/MiscController.dart';

part 'password_change_state.dart';

class PasswordChangeCubit extends Cubit<PasswordChangeState> {
  PasswordChangeCubit() : super(PasswordChangeInitial());

  final _miscController = MiscController();
  API api = API();

  Future<void> submitData({
    required BuildContext context,
    required Function(bool isSuccess, String message) onComplete,
    required String oldPass,
    required String newPass,
    required String confirmPass,
  }) async {


    _miscController.showAlertDialog(
      context: context,
      cancelable: false,
      title: "Do you want to change your password?",
      subTitle: "",
      okText: "Send",
      okPressed: () async {
        _miscController.navigateBack(context: context);
        _miscController.showProgressDialog(context: context);

        await _miscController.checkInternet().then((value) async {
          if (!value.contains('ignore')) {
            try {

              // ✅ Wrap in FormData
              FormData formData = FormData.fromMap({
                "old_password": oldPass,
                "new_password": newPass,
                "confirm_password": confirmPass
              });

              // ✅ Send API Request
              var apiResponse = await api.postData(
                endpoint: "/change-password/",
                token: AppCache().userInfo?.token.toString(),
                data: formData, // ✅ Pass FormData directly
              );

              var response = jsonDecode(apiResponse);
              var success = response['Success'];
              var message = response['Message'];

              _miscController.navigateBack(context: context);

              if (success) {
                print("API Response: $response");
                onComplete(true, 'submitted successfully');
                emit(PasswordChangeLoaded(success: true, message: "Successfully done"));
              } else {
                onComplete(false, 'Upload Failed: $message');
                emit(PasswordChangeLoaded(success: false, message: "Something went wrong ,Please try again"));
              }
            } catch (e) {
              print("Upload Error: $e");
              onComplete(false, 'Something went wrong ,Please try again');
              emit(PasswordChangeLoaded(success: false, message: "Something went wrong"));
            }
          } else {
            onComplete(false, "Internet Error!\nYou are offline, Please check your internet connection.");
            emit(PasswordChangeLoaded(success: false, message: "Something went wrong"));
          }
        });
      },
      cancelText: "No",
      cancelPressed: () {
        _miscController.navigateBack(context: context);
      },
    );
  }


}
