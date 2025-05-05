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
    _miscController.navigateBack(context: context);
    _miscController.showProgressDialog(context: context);

    await _miscController.checkInternet().then((value) async {
      if (!value.contains('ignore')) {
        try {
          // Prepare FormData
          FormData formData = FormData.fromMap({
            "email": email
          });

          // Send API Request
          var apiResponse = await api.updateData(
            endpoint: "/send-forgot-otp/",
            data: formData, // Pass FormData directly
          );

          var response = jsonDecode(apiResponse);
          var success = response['Success'];
          var message = response['Message'];

          _miscController.navigateBack(context: context);

          if (success) {

            var packet = response['Packet'];
            onComplete(true, 'Email sent');
            emit(ForgePassLoadedState(success: true, message: message));
          } else {
            onComplete(false, 'Failed: $message');
            emit(ForgePassLoadedState(success: false, message: "Something went wrong"));
          }
        } catch (e) {
          print(" Error: $e");
          onComplete(false, ' Error: ${e.toString()}');
        }
      } else {
        onComplete(false, "Internet Error!\nYou are offline, Please check your internet connection.");
        emit(ForgePassLoadedState(success: false, message: "Something went wrong"));
      }
    });
  }


 varifyOTP({
   required BuildContext context,
   required String email,
   required Function(bool isSuccess, String message) onComplete,
 }) async {
   _miscController.navigateBack(context: context);
   _miscController.showProgressDialog(context: context);

   await _miscController.checkInternet().then((value) async {
     if (!value.contains('ignore')) {
       try {
         // Prepare FormData
         FormData formData = FormData.fromMap({
           "email": email
         });

         // Send API Request
         var apiResponse = await api.updateData(
           endpoint: "/send-forgot-otp/",
           data: formData, // Pass FormData directly
         );

         var response = jsonDecode(apiResponse);
         var success = response['Success'];
         var message = response['Message'];

         _miscController.navigateBack(context: context);

         if (success) {

           var packet = response['Packet'];
           onComplete(true, 'Email sent');
           emit(ForgePassLoadedState(success: true, message: message));
         } else {
           onComplete(false, 'Failed: $message');
           emit(ForgePassLoadedState(success: false, message: "Something went wrong"));
         }
       } catch (e) {
         print(" Error: $e");
         onComplete(false, ' Error: ${e.toString()}');
       }
     } else {
       onComplete(false, "Internet Error!\nYou are offline, Please check your internet connection.");
       emit(ForgePassLoadedState(success: false, message: "Something went wrong"));
     }
   });
 }

  createNew({
    required BuildContext context,
    required String email,
    required Function(bool isSuccess, String message) onComplete,
  }) async {
    _miscController.navigateBack(context: context);
    _miscController.showProgressDialog(context: context);

    await _miscController.checkInternet().then((value) async {
      if (!value.contains('ignore')) {
        try {
          // Prepare FormData
          FormData formData = FormData.fromMap({
            "email": email
          });

          // Send API Request
          var apiResponse = await api.updateData(
            endpoint: "/send-forgot-otp/",
            data: formData, // Pass FormData directly
          );

          var response = jsonDecode(apiResponse);
          var success = response['Success'];
          var message = response['Message'];

          _miscController.navigateBack(context: context);

          if (success) {

            var packet = response['Packet'];
            onComplete(true, 'Email sent');
            emit(ForgePassLoadedState(success: true, message: message));
          } else {
            onComplete(false, 'Failed: $message');
            emit(ForgePassLoadedState(success: false, message: "Something went wrong"));
          }
        } catch (e) {
          print(" Error: $e");
          onComplete(false, ' Error: ${e.toString()}');
        }
      } else {
        onComplete(false, "Internet Error!\nYou are offline, Please check your internet connection.");
        emit(ForgePassLoadedState(success: false, message: "Something went wrong"));
      }
    });
  }

}
