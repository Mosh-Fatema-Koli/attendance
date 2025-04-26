import 'dart:convert';

import 'package:attendance/view/all/Leave_filter/model/filter_model.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

import '../../../../api_service/ApiController.dart';
import '../../../../api_service/app_cash.dart';
import '../../../../common_controller/MiscController.dart';
import '../../nab_bar.dart';
import 'filter_Repository.dart';

part 'leave_filter_state.dart';

class LeaveFilterCubit extends Cubit<LeaveFilterState> {
  LeaveFilterCubit() : super(LeaveFilterInitial());

  final _miscController = MiscController();
  final _repository = FilterRepository();
  API api = API();

  loadData({BuildContext? context, String? month , String? year, String? date,required bool isLeave}) {
    if(context != null){
      _miscController.showProgressDialog(context: context);
    }
    date==null?  _repository.srcByMonthYear(
      onComplete: (isSuccess, message, dataList) {
        if(context != null){
          Navigator.pop(context);
        }
        emit(LeaveFilterLoadedState(success: isSuccess, message: message, listOfData: dataList));
      },month: month!,year: year!,isLeave: isLeave): _repository.srcByDate(date: date,isLeave: isLeave,
      onComplete: (isSuccess, message, dataList) {
        if(context != null){
          Navigator.pop(context);
        }
        emit(LeaveFilterLoadedState(success: isSuccess, message: message, listOfData: dataList));
      },);
  }


  Future<void> delete({
    required BuildContext context,
    required Function(bool isSuccess, String message) onComplete,
    required int id,
    required bool isLeave,
  }) async {
    _miscController.showAlertDialog(
      context: context,
      cancelable: false,
      title: "Do you want to Delete?",
      subTitle: "",
      okText: "Yes",
      okPressed: () async {
        _miscController.navigateBack(context: context);
        _miscController.showProgressDialog(context: context);
        await _miscController.checkInternet().then((value) async {
          if (!value.contains('ignore')) {
            try {
              var apiResponse = await api.deleteData(
                endpoint: isLeave==true?"/leaveapplication/$id/":"/wfhapplication/$id/",
                token: AppCache().userInfo?.token.toString(),
                // ✅ Pass FormData directly
              );

              var response = jsonDecode(apiResponse);
              var success = response['Success'];
              var message = response['Packet']['message'];

              _miscController.navigateBack(context: context);

              if (success) {
                print("API Response: $response");
                _miscController.toast(msg: message,);
                _miscController.navigateBack(context: context,);
                onComplete(true, '$message');

              } else {
                onComplete(false, 'Upload Failed: $message');
              }
            } catch (e) {
              print("Upload Error: $e");
              onComplete(false, 'Upload Error: ${e.toString()}');

            }
          } else {
            onComplete(false, "Internet Error!\nYou are offline, Please check your internet connection.");
          }
        });
      },
      cancelText: "No",
      cancelPressed: () {
        _miscController.navigateBack(context: context);
      },
    );
  }
}
