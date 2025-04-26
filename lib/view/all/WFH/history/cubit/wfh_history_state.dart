

import '../../../Leave/history/model/leave_model.dart';

sealed class WFHHistoryState {

  bool success=false;
  String message="";
  List<LeaveModel>listOfData = [];


  @override
  List<Object> get props => [success, message, listOfData,];
}

final class WFHHistoryInitial extends WFHHistoryState {}


final class WFHHistoryLoadedState extends WFHHistoryState {
  WFHHistoryLoadedState(
      {bool? success, bool? summarySuccess, String? message, List<LeaveModel>? listOfData,}) {
    this.success = success ?? this.success;
    this.message = message ?? this.message;
    this.listOfData = listOfData ?? this.listOfData;
  }

}