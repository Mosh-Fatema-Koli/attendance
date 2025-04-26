import 'package:flutter/cupertino.dart';

@immutable
abstract class LoginState {}

class LoginInitial extends LoginState {
  final bool isPasswordVisible;
  final bool success;
  final String message;
  LoginInitial(
      {required this.isPasswordVisible,
      required this.message,
      required this.success});


//value change
  static LoginInitial copyWith({
    required bool isPasswordVisible,
    required bool success,
    required String message,
  }) {
    return LoginInitial(
        isPasswordVisible: isPasswordVisible,
        message: message,
        success: success);
  }

  @override
  List<Object> get props => [isPasswordVisible, success, message];
}
