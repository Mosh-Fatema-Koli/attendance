

import 'dart:convert';
import 'package:attendance/view/all/Attendance/model/attendance_filter.dart';
import 'package:attendance/view/all/Attendance/model/attendance_history.dart';
import 'package:attendance/view/all/Leave/history/model/leave_model.dart';
import '../../../../../api_service/ApiController.dart';
import '../../../../../api_service/Constant.dart';
import '../../../../../api_service/app_cash.dart';
import '../../../../../common_controller/MiscController.dart';


class WFHRepository {

  API api = API();
  final _miscController = MiscController();

  //region fetchData
  fetchData({ required Function(bool isSuccess, String message, List<LeaveModel> dataList) onComplete}) async {
    List<LeaveModel> list = [];
    await _miscController.checkInternet().then((value) async {
      if (!value.contains('ignore')) {
        var apiResponse = await api.fetchListData(endpoint: "/wfhapplication/" ,token: AppCache().userInfo?.token.toString());
        var success = jsonDecode(apiResponse)['Success'];
        var message = jsonDecode(apiResponse)['Message'];
        if (success) {
          try {
            var packetList = jsonDecode(apiResponse)['PacketList'];
            if(packetList!=null){
              list.clear();
              for (var item in packetList) {
                LeaveModel object = LeaveModel.fromJson(item);
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


  //region delete
  deletedata(){


  }
  //endregion


}