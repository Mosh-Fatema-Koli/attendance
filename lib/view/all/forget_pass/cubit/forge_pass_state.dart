part of 'forge_pass_cubit.dart';

@immutable
sealed class ForgePassState {
  bool success=false;
  String message="";
  String email="";


  @override
  List<Object> get props => [success, message,email];
}

final class ForgePassInitial extends ForgePassState {}


final class ForgePassLoadedState extends ForgePassState {
  ForgePassLoadedState(
      {bool? success, String? message,String? email,}) {
    this.success = success ?? this.success;
    this.message = message ?? this.message;
    this.email = email ?? this.email;
  }
}
