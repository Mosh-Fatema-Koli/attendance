import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:network_info_plus/network_info_plus.dart';
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

  Future<void> openCamera([bool useFrontCamera = false]) async {
    try {
      cameras = await availableCameras();
      _selectedCameraIndex = useFrontCamera
          ? cameras.indexWhere((camera) => camera.lensDirection == CameraLensDirection.front)
          : cameras.indexWhere((camera) => camera.lensDirection == CameraLensDirection.back);

      if (_selectedCameraIndex == -1) {
        emit(CheckInError("No camera found!"));
        return;
      }

      controller = CameraController(
        cameras[_selectedCameraIndex],
        ResolutionPreset.high,
        enableAudio: false, // Disable audio for performance
      );

      await controller.initialize();
      emit(CheckInCameraOpened(controller, useFrontCamera));
    } catch (e) {
      emit(CheckInError("Camera initialization failed: $e"));
    }
  }

  Future<void> toggleCamera() async {
    _selectedCameraIndex = (_selectedCameraIndex + 1) % cameras.length;
    await openCamera(cameras[_selectedCameraIndex].lensDirection == CameraLensDirection.front);
  }

  Future<void> toggleFlash() async {
    try {
      if (!controller.value.isInitialized) return;

      flashMode = (flashMode == FlashMode.off) ? FlashMode.torch : FlashMode.off;
      await controller.setFlashMode(flashMode);

      emit(CheckInCameraOpened(controller, state.useFrontCamera));
    } catch (e) {
      emit(CheckInError("Flash toggle failed: ${e.toString()}"));
    }
  }

  Future<void> captureImage(BuildContext context) async {
    try {
      if (!controller.value.isInitialized) return;
      final XFile? image = await controller.takePicture();

      if (image == null || image.path.isEmpty) {
        emit(CheckInError("Image capture failed"));
        return;
      }

      emit(CheckInLoaded(cameraPath: image.path));
    } catch (e) {
      emit(CheckInError("Capture error: $e"));
    }
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
      subTitle: "MAC Address: $macAddress ,\nattendance_type: ${attendance_type == 0 ? "Entry" : "Exit"}",
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

                onComplete(true, '$message');
                emit(CheckInLoaded(success: true, message: message));
              } else {
                onComplete(false, 'Upload Failed: $message');
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
    try {
      final info = NetworkInfo();
      return await info.getWifiBSSID(); // Router MAC, not device MAC
    } catch (e) {
      print("MAC Address Error: $e");
      return null;
    }
  }


  @override
  Future<void> close() async {
    await controller.dispose();
    super.close();
  }

}



