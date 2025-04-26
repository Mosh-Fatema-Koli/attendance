

import 'dart:convert';
import 'package:attendance/view/all/Attendance/model/attendance_filter.dart';
import 'package:attendance/view/all/Attendance/model/attendance_history.dart';
import '../../../../../api_service/ApiController.dart';
import '../../../../../api_service/Constant.dart';
import '../../../../../api_service/app_cash.dart';
import '../../../../../common_controller/MiscController.dart';
import '../model/filter_model.dart';


class FilterRepository {

  API api = API();
  final _miscController = MiscController();

  //region fetchData
  Future srcByMonthYear({ required Function(bool isSuccess, String message,List<FilterModel> dataList) onComplete,required String month ,required String year,required bool isLeave  }) async {
    List<FilterModel> list = [];
    await _miscController.checkInternet().then((value) async {
      if (!value.contains('ignore')) {
        var apiResponse = isLeave==true? await api.fetchListData(endpoint: "/leaveapplication/?month=$month&year=$year" ,token: AppCache().userInfo?.token.toString()): await api.fetchListData(endpoint: "/wfhapplication/?month=$month&year=$year" ,token: AppCache().userInfo?.token.toString());
        var success = jsonDecode(apiResponse)['Success'];
        var message = jsonDecode(apiResponse)['message'];
        if (success) {
          try {
            var packetList = jsonDecode(apiResponse)['PacketList'];
            if(packetList!=null){
              list.clear();
              for (var item in packetList) {
                FilterModel object = FilterModel.fromJson(item);
                list.add(object);
              }
              onComplete(true, 'Data downloaded successfully', list);
            } else {
              onComplete(false, 'Download Error!\nAPI response packet is Null', list);
            }
          } catch (ex) {
            onComplete(false, 'Download Error!\n${ex.toString()}', list);
          }
        } else {
          onComplete(false, 'Download Error!\n$message', list);
        }
      } else {
        onComplete(false, "Internet Error!\nYou are offline, Please check your internet connection.", list);
      }
    });
  }
  //endregion

  //region Data
  Future srcByDate({ required String date,required bool isLeave ,required Function(bool isSuccess, String message, List<FilterModel> dataList) onComplete}) async {
    List<FilterModel> list = [];
    await _miscController.checkInternet().then((value) async {
      if (!value.contains('ignore')) {
        var apiResponse =  isLeave==true?await api.fetchListData(endpoint: "/leaveapplication/?created_at=$date",token: AppCache().userInfo?.token.toString()): await api.fetchListData(endpoint: "/wfhapplication/?created_at=$date",token: AppCache().userInfo?.token.toString());
        var success = jsonDecode(apiResponse)['Success'];
        var message = jsonDecode(apiResponse)['Message'];
        if (success) {
          try {
            var packetList = jsonDecode(apiResponse)['PacketList'];
            if(packetList!=null){
              list.clear();
              for (var item in packetList) {
                FilterModel object = FilterModel.fromJson(item);
                list.add(object);
              }
              onComplete(true, 'Data downloaded successfully', list);
            } else {
              onComplete(false, 'Download Error!\nAPI response packet is Null', list);
            }
          } catch (ex) {
            onComplete(false, 'Download Error!\n${ex.toString()}', list);
          }
        } else {
          onComplete(false, 'Download Error!\n$message', list);
        }
      } else {
        onComplete(false, "Internet Error!\nYou are offline, Please check your internet connection.", list);
      }
    });
  }
  //endregion


}