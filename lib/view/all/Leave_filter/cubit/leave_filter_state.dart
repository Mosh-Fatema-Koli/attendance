part of 'leave_filter_cubit.dart';

@immutable
sealed class LeaveFilterState {

  bool success=false;
  String message="";
  List<FilterModel>listOfData = [];

  @override
  List<Object> get props => [ success,message,listOfData,];
}

final class LeaveFilterInitial extends LeaveFilterState {}

final class LeaveFilterLoadedState extends LeaveFilterState {
  LeaveFilterLoadedState({bool? success, String? message,List<FilterModel>? listOfData }) {
    this.success = success ?? this.success;
    this.message = message ?? this.message;
    this.listOfData = listOfData ?? this.listOfData;
  }

}
