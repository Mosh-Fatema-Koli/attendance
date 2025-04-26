

import 'package:camera/camera.dart';

abstract class CheckInState {
  bool success=false;
  bool useFrontCamera=false;
  String message="";
  String cameraPath="";


  @override
  List<Object> get props => [success, message, cameraPath,useFrontCamera];

}

final class CheckInInitial extends CheckInState {}


class CheckInCameraOpened extends CheckInState {
  final CameraController cameraController;
  CheckInCameraOpened(this.cameraController, bool bool);
}

class CheckInError extends CheckInState {
  final String errorMessage;
  CheckInError(this.errorMessage);
}

final class CheckInLoaded extends CheckInState {
  CheckInLoaded(
      {bool? success,bool? useFrontCamera, String? message, String? cameraPath}) {
    this.success = useFrontCamera ?? this.useFrontCamera;
    this.success = success ?? this.success;
    this.cameraPath = cameraPath ?? this.cameraPath;
    this.message = message ?? this.message;
  }

}
