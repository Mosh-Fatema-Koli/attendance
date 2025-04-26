import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../api_service/ApiController.dart';
import '../../../../api_service/Constant.dart';
import '../../../../api_service/app_cash.dart';
import '../../../../common_controller/MiscController.dart';
import '../../../../common_model/UserInfo.dart';

part 'update_profile_state.dart';

class UpdateProfileCubit extends Cubit<UpdateProfileState> {
  UpdateProfileCubit() : super(UpdateProfileInitial());

  API api = API();
  final _miscController = MiscController();

  Future<File?> selectImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      emit(UpdateProfileLoaded(success: true, cameraPath: image.path));
      return File(image.path);

    } else {
      // User canceled the picker
      return null;
    }
  }


  void updateProfile({
    required BuildContext context,
    required String name,
    required String phone,
    required String dob,
    required String imagePath,
    required Function(bool isSuccess, String message) onComplete,
  }) async {
    _miscController.showAlertDialog(
      context: context,
      cancelable: false,
      title: "Do you want to Update?",
      subTitle: "Name: $name,\nPhone Number: $phone,\nDate of birth: $dob",
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
                multipartFile = MultipartFile.fromBytes([], filename: "self.jpg");
              }
              // Convert the dates from dd-MM-yyyy to yyyy-MM-dd format
              DateFormat inputFormat = DateFormat("dd-MM-yyyy");
              DateTime doB = inputFormat.parse(dob);


              String formatteddoB= DateFormat("yyyy-MM-dd").format(doB);


              // Prepare FormData
              FormData formData = FormData.fromMap({
                  "name": name,
                  "phone": phone,
                  "date_of_birth": formatteddoB,
                   "image": multipartFile,  // Attach the image if it's valid
              });

              // Send API Request
              var apiResponse = await api.updateData(
                endpoint: "/update_profile/",
                token: AppCache().userInfo?.token.toString(),
                data: formData, // Pass FormData directly
              );

              var response = jsonDecode(apiResponse);
              var success = response['Success'];
              var message = response['Message'];

              _miscController.navigateBack(context: context);

              if (success) {

                var packet = response['Packet'];
                UserInfo user = UserInfo.fromJson(packet);
                SharedPreferences preference = await _miscController.pref();
                _miscController.prefSetString(pref: preference, key: Constant.userInfoPref, value: userInfoToJson(user));
                AppCache(userInfo: user);
                onComplete(true, 'Your profile updated successfully');
                emit(UpdateProfileLoaded(success: true, message: message));
              } else {
                onComplete(false, 'Upload Failed: $message');
                emit(UpdateProfileLoaded(success: false, message: "Something went wrong"));
              }
            } catch (e) {
              print("Upload Error: $e");
              onComplete(false, 'Upload Error: ${e.toString()}');
            }
          } else {
            onComplete(false, "Internet Error!\nYou are offline, Please check your internet connection.");
            emit(UpdateProfileLoaded(success: false, message: "Something went wrong"));
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
