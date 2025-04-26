part of 'atteendance_history_cubit.dart';

abstract class AttendanceHistoryState {
  bool success=false;
  bool summarySuccess=false;
  String message="";
  List<AttendanceHistory>listOfData = [];


  @override
  List<Object> get props => [success, message, listOfData,summarySuccess];
}

final class AttendanceHistoryInitial extends AttendanceHistoryState {}

final class AttendanceHistoryLoadedState extends AttendanceHistoryState {
  AttendanceHistoryLoadedState(
      {bool? success, bool? summarySuccess, String? message, List<AttendanceHistory>? listOfData,MyAttendanceFilter? summary }) {
    this.success = success ?? this.success;
    this.summarySuccess = summarySuccess ?? this.summarySuccess;
    this.message = message ?? this.message;
    this.listOfData = listOfData ?? this.listOfData;
  }

}
