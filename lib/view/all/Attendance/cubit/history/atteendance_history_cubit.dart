import 'package:attendance/view/all/Attendance/model/attendance_history.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import '../../../../../common_controller/MiscController.dart';
import '../../model/attendance_filter.dart';
import 'attendance_Repository.dart';

part 'atteendance_history_state.dart';

class AttendanceHistoryCubit extends Cubit<AttendanceHistoryState> {
  AttendanceHistoryCubit() : super(AttendanceHistoryInitial());

  final _repository = AttendanceHistoryRepository();
  final _miscController = MiscController();

  loadData({BuildContext? context}) {
    if(context != null){
      _miscController.showProgressDialog(context: context);
    }
    _repository.fetchData(
      onComplete: (isSuccess, message, dataList) {
        if(context != null){
          Navigator.pop(context);
        }
        emit(AttendanceHistoryLoadedState(success: isSuccess, message: message, listOfData: dataList));
      },);
  }

  filter({BuildContext? context,required String date}) {
    if(context != null){
      _miscController.showProgressDialog(context: context);
    }
    _repository.filterByDate(datalist: state.listOfData,date: date,
      onComplete: (isSuccess, message, dataList) {
        if(context != null){
          Navigator.pop(context);
        }
        emit(AttendanceHistoryLoadedState(success: isSuccess, message: message, listOfData: dataList));
      },);
  }


}
