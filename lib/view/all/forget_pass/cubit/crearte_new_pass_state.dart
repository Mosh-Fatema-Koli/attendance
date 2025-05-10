part of 'crearte_new_pass_cubit.dart';

@immutable

sealed class CrearteNewPassState {
  bool success=false;
  String message="";
  String email="";


  @override
  List<Object> get props => [success, message,email,];
}

final class CreateNewPassInitial extends CrearteNewPassState {}


final class CreateNewPassLoadedState extends CrearteNewPassState {
  CreateNewPassLoadedState(
      {bool? success, String? message,String? email,}) {
    this.success = success ?? this.success;
    this.message = message ?? this.message;
    this.email = email ?? this.email;
  }
}
