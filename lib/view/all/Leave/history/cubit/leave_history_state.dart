


import '../model/leave_model.dart';

sealed class LeaveHistoryState {

  bool success=false;
  String message="";
  List<LeaveModel>listOfData = [];


  @override
  List<Object> get props => [success, message, listOfData,];
}

final class LeaveHistoryInitial extends LeaveHistoryState {}


final class LeaveHistoryLoadedState extends LeaveHistoryState {
  LeaveHistoryLoadedState(
      {bool? success, bool? summarySuccess, String? message, List<LeaveModel>? listOfData,}) {
    this.success = success ?? this.success;
    this.message = message ?? this.message;
    this.listOfData = listOfData ?? this.listOfData;
  }

}