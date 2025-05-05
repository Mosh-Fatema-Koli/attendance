import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';

import '../../../../../api_service/ApiController.dart';
import '../../../../../api_service/app_cash.dart';
import '../../../../../common_controller/MiscController.dart';

part 'wfhentry_state.dart';

class WfhentryCubit extends Cubit<WfhentryState> {
  WfhentryCubit() : super(WfhentryState(
    cameraPath: '',
    message: '',
    success: false,
  ));

  final ImagePicker _picker = ImagePicker();
  API api = API();
  final _miscController = MiscController();

  void setLeaveType(String? newType) {
    emit(state.copyWith(leaveType: newType));
  }

  void selectImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      emit(state.copyWith(cameraPath: image.path));
    }
  }

  void submitData({
    required BuildContext context,
    required String startDate,
    required String endDate,
    required String reason,
    required String imagePath,
    required Function(bool isSuccess, String message) onComplete,
  }) async {
    _miscController.showAlertDialog(
      context: context,
      cancelable: false,
      title: "Do you want to send?",
      subTitle: "\nStart date: $startDate,\nEnd date: $endDate",
      okText: "Send",
      okPressed: () async {
        _miscController.navigateBack(context: context);
        _miscController.showProgressDialog(context: context);

        await _miscController.checkInternet().then((value) async {
          if (!value.contains('ignore')) {
            try {
              // Validate File Exists
              File imageFile = File(imagePath);
              MultipartFile multipartFile;

              if (imagePath.isNotEmpty && await imageFile.exists()) {
                // If the image exists, attach it
                multipartFile = await MultipartFile.fromFile(
                  imageFile.path,
                  filename: "attendance_image.jpg",  // Adjust the filename as needed
                );
              } else {
                // If no image exists, pass an empty file or skip the field entirely
                multipartFile = MultipartFile.fromBytes([], filename: "attendance_image.jpg");
              }


              String formattedStartDate = startDate;
              String formattedEndDate = endDate;

              // Prepare FormData
              FormData formData = FormData.fromMap({
                "start_date": formattedStartDate,
                "end_date": formattedEndDate,
                "reason": reason,
                "image": imagePath.isNotEmpty?multipartFile:"",   // Attach the image if it's valid
              });

              // Send API Request
              var apiResponse = await api.postData(
                endpoint: "/wfhapplication/",
                token: AppCache().userInfo?.token.toString(),
                data: formData, // Pass FormData directly
              );

              var response = jsonDecode(apiResponse);
              var success = response['Success'];
              var message = response['Message'];

              _miscController.navigateBack(context: context);

              if (success) {
                onComplete(true, 'Your request added successfully');
                emit(state.copyWith(success: true, message: message));
              } else {
                onComplete(false, 'Upload Failed: $message');
                emit(state.copyWith(success: false, message: "Something went wrong"));
              }
            } catch (e) {
              print("Upload Error: $e");
              onComplete(false, 'Upload Error: ${e.toString()}');
            }
          } else {
            onComplete(false, "Internet Error!\nYou are offline, Please check your internet connection.");
            emit(state.copyWith(success: false, message: "Something went wrong"));
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