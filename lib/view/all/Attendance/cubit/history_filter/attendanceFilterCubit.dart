import 'package:attendance/view/all/Attendance/model/attendance_history.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import '../../../../../common_controller/MiscController.dart';
import '../../../Home/model/menu_model.dart';
import '../../model/attendance_filter.dart';
import 'atteendance_filter_state.dart';
import 'attendance_filtrt_Repository.dart';

class AttendanceFilterCubit extends Cubit<AttendanceFilterState> {
  AttendanceFilterCubit() : super(AttendanceFilterInitial());

  final _repository = AttendanceFilterRepository();
  final _miscController = MiscController();

  Future<void> summaryLoadData({
    BuildContext? context,
    required String month,
    required String year,
  }) async {
    if (context != null) {
      _miscController.showProgressDialog(context: context);
    }

    try {
      await _repository.summaryData(
        year: year,
        month: month,
        onComplete: (isSuccess, message, data) {
          if (context != null) {
            Navigator.pop(context);
          }
          emit(AttendanceFilterLoadedState(success: isSuccess, message: message, summary: data));
        },
      );
    } catch (e) {
      if (context != null) {
        Navigator.pop(context);
      }
      emit( AttendanceFilterLoadedState(success: false, message: "An error occurred", summary: MyAttendanceFilter()));
    }
  }
}
