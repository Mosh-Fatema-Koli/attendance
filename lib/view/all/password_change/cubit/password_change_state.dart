part of 'password_change_cubit.dart';

abstract class PasswordChangeState {
  bool success=false;
  String message="";

  @override
  List<Object> get props => [success, message,];
}

final class PasswordChangeInitial extends PasswordChangeState {}

final class PasswordChangeLoaded extends PasswordChangeState {
  PasswordChangeLoaded({bool? success, bool? summarySuccess, String? message,}) {
    this.success = success ?? this.success;
    this.message = message ?? this.message;
  }


}


