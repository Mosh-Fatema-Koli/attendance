
import '../../../Home/model/menu_model.dart';
import '../../model/attendance_filter.dart';

abstract class AttendanceFilterState {
  bool success=false;
  String message="";
  MyAttendanceFilter summary = MyAttendanceFilter();
  final List summaryList=[
    MenuModel(name: "Total Present",image: ""),
    MenuModel(name: "Total Absent",image: ""),
    MenuModel(name: "TL_Hours",image: ""),
    MenuModel(name: "Total late",image: ""),
    MenuModel(name: "Total early",image: ""),
    MenuModel(name: "TE_Hours",image: ""),
  ];

  @override
  List<Object> get props => [ success,message,summary,];
}

final class AttendanceFilterInitial extends AttendanceFilterState {}

final class AttendanceFilterLoadedState extends AttendanceFilterState {
  AttendanceFilterLoadedState({bool? success, String? message,MyAttendanceFilter? summary }) {
    this.success = success ?? this.success;
    this.message = message ?? this.message;
    this.summary = summary ?? this.summary;
  }

}
