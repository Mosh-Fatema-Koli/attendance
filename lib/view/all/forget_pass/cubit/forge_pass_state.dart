part of 'forge_pass_cubit.dart';

@immutable
sealed class ForgePassState {
  bool success=false;
  String message="";


  @override
  List<Object> get props => [success, message,];
}

final class ForgePassInitial extends ForgePassState {}


final class ForgePassLoadedState extends ForgePassState {
  ForgePassLoadedState(
      {bool? success, String? message,}) {
    this.success = success ?? this.success;
    this.message = message ?? this.message;
  }
}
