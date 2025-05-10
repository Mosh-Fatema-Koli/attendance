import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

import '../../../../api_service/ApiController.dart';
import '../../../../common_controller/MiscController.dart';

part 'crearte_new_pass_state.dart';

class CreateNewPassCubit extends Cubit<CrearteNewPassState> {
  CreateNewPassCubit() : super(CreateNewPassInitial());

  API api = API();
  final _miscController = MiscController();

  Future<void> createNew({
    required BuildContext context,
    required String email,
    required String newPass,
    required String confirmPass,
    required Function(bool isSuccess, String message) onComplete,
  }) async {
    _miscController.showProgressDialog(context: context);

    final hasInternet = await _miscController.checkInternet();
    if (hasInternet.contains('ignore')) {
      _miscController.navigateBack(context: context);
      onComplete(false, "Internet Error!\nYou are offline. Please check your internet connection.");
      emit(CreateNewPassLoadedState(success: false, message: "No Internet"));
      return;
    }

    try {
      // Prepare FormData
      final formData = FormData.fromMap({

        "email":email,
        "new_password": newPass,
        "confirm_password": confirmPass
      });

      // Debug print (optional)
      print("Sending FormData: $formData");

      // API request
      final apiResponse = await api.postData(
        endpoint: "/reset-password/",
        data: formData,
      );

      final response = jsonDecode(apiResponse);
      final success = response['Success'] ?? false;
      final message = response['Message'] ?? "No message";

      _miscController.navigateBack(context: context);

      if (success) {
        onComplete(true, 'Password changed successfully');
        emit(CreateNewPassLoadedState(success: true, message: 'Password changed successfully'));
      } else {
        onComplete(false, message);
        emit(CreateNewPassLoadedState(success: false, message: message));
      }
    } catch (e) {
      _miscController.navigateBack(context: context);
      final errorMsg = 'Something went wrong: ${e.toString()}';
      print("Error: $errorMsg");
      onComplete(false, errorMsg);
      emit(CreateNewPassLoadedState(success: false, message: errorMsg));
    }
  }

}
