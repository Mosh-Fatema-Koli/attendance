import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../../api_service/ApiController.dart';
import '../../../../../api_service/app_cash.dart';
import '../../../../../common_controller/MiscController.dart';
import 'check_in_state.dart';


class CheckInCubit extends Cubit<CheckInState> {
  CheckInCubit() : super(CheckInInitial());

  late CameraController controller;
  late List<CameraDescription> cameras;
  API api = API();
  final _miscController = MiscController();
  int _selectedCameraIndex = 0;
  FlashMode flashMode = FlashMode.off; // Track flash state

  final ImagePicker _picker = ImagePicker();

  Future<void> pickImageFromCamera() async {
    try {
      emit(CheckInInitial()); // Reset any previous state

      final XFile? image = await _picker.pickImage(source: ImageSource.camera);

      if (image == null || image.path.isEmpty) {
        emit(CheckInError("No image captured"));
        return;
      }

      emit(CheckInLoaded(cameraPath: image.path));
    } catch (e) {
      emit(CheckInError("Image capture failed: $e"));
    }
  }

  Future<void> retakeImage() async {
    await pickImageFromCamera();
  }

  void resetState() {
    emit(CheckInInitial());
  }


  Future<void> submitData({
    required BuildContext context,
    required Function(bool isSuccess, String message) onComplete,
    required String image,
    required int attendance_type,
  }) async {
    // ✅ Get MAC Address
    String? macAddress = await getMacAddress();

    _miscController.showAlertDialog(
      context: context,
      cancelable: false,
      title: "Do you want to send?",
      subTitle: "MAC Address: ${macAddress??"a8-6e-84-ca-d7-8c"} ,\nattendance_type: ${attendance_type == 0 ? "Entry" : "Exit"}",
      okText: "Send",
      okPressed: () async {
        _miscController.navigateBack(context: context);
        _miscController.showProgressDialog(context: context);

        print("MAC Address: $macAddress");

        await _miscController.checkInternet().then((value) async {
          if (!value.contains('ignore')) {
            try {
              // ✅ Validate File Exists
              File imageFile = File(image);
              if (!imageFile.existsSync()) {
                print("Error: Image file not found at path: $image");
                emit(CheckInError("Image file not found"));
                return;
              }

              // ✅ Convert Image to MultipartFile
              MultipartFile multipartFile = await MultipartFile.fromFile(
                imageFile.path,
                filename: "attendance_image.jpg",
              );

              // ✅ Wrap in FormData
              FormData formData = FormData.fromMap({
                "image": multipartFile,
                "attendance_type": attendance_type == 0 ? "entry" : "exit",
               // "mac_address": macAddress,
                "mac_address": macAddress,
              });

              // ✅ Send API Request
              var apiResponse = await api.postData(
                endpoint: "/submit-attendance/",
                token: AppCache().userInfo?.token.toString(),
                data: formData, // ✅ Pass FormData directly
              );

              var response = jsonDecode(apiResponse);
              var success = response['Success'];
              var message = response['Packet']['error'];

              _miscController.navigateBack(context: context);

              if (success) {
                print("API Response: $response");

                onComplete(true, 'Submitted successfully');
                emit(CheckInLoaded(success: true, message: "Submitted successfully"));
              } else {
                onComplete(false, "Not submitted ,something went wrong");
                emit(CheckInLoaded(success: false, message: "Something went wrong"));
              }
            } catch (e) {
              print("Upload Error: $e");
              onComplete(false, 'Upload Error: ${e.toString()}');
              emit(CheckInError("Upload failed: ${e.toString()}"));
            }
          } else {
            onComplete(false, "Internet Error!\nYou are offline, Please check your internet connection.");
            emit(CheckInLoaded(success: false, message: "Something went wrong"));
          }
        });
      },
      cancelText: "No",
      cancelPressed: () {
        _miscController.navigateBack(context: context);
      },
    );
  }


// ✅ Get MAC Address (BSSID)
  Future<String?> getMacAddress() async {
    // const MethodChannel _channel = MethodChannel('network_info');
    //
    // Future<String?> getRouterMacAddress() async {
    //   try {
    //     final String? macAddress = await _channel.invokeMethod('getRouterMacAddress');
    //     return macAddress;
    //   } on PlatformException catch (e) {
    //     print("Failed to get MAC: ${e.message}");
    //     return null;
    //   }
    // }
    //
      final info = NetworkInfo();
      String? macAddress;

      // Ask for location permission
      var status = await Permission.location.request();

      if (status.isGranted) {
        try {
          macAddress = await info.getWifiBSSID();
          print('✅ MAC/BSSID Address Retrieved: $macAddress');
          return macAddress;
        } catch (e) {
          macAddress = 'Error getting MAC/BSSID.';
          print('❌ Failed to get MAC address: $e');
          return null;
        }
      } else {
        macAddress = 'Permission denied.';
        print('❌ Location permission not granted');
        return null;
      }

  }


  @override
  Future<void> close() async {
    await controller.dispose();
    super.close();
  }

}



