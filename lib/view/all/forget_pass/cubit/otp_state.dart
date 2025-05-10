part of 'otp_cubit.dart';

@immutable
sealed class OtpState {
  bool success=false;
  String message="";
  String email="";


  @override
  List<Object> get props => [success, message,email,];
}

final class OtpInitial extends OtpState {}


final class OtpLoadedState extends OtpState {
  OtpLoadedState(
      {bool? success, String? message,String? email,}) {
    this.success = success ?? this.success;
    this.message = message ?? this.message;
    this.email = email ?? this.email;
  }
}
