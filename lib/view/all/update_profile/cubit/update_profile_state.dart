part of 'update_profile_cubit.dart';

@immutable
sealed class UpdateProfileState {
  bool success=false;
  String message="";
  String cameraPath="";


  @override
  List<Object> get props => [success, message, cameraPath,];
}

final class UpdateProfileInitial extends UpdateProfileState {}

final class UpdateProfileLoaded extends UpdateProfileState {
  UpdateProfileLoaded({bool? success,String? message, String? cameraPath}) {
    this.success = success ?? this.success;
    this.cameraPath = cameraPath ?? this.cameraPath;
    this.message = message ?? this.message;
  }

}
