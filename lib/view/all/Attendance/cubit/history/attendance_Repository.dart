

import 'dart:convert';
import 'package:attendance/view/all/Attendance/model/attendance_filter.dart';
import 'package:attendance/view/all/Attendance/model/attendance_history.dart';
import '../../../../../api_service/ApiController.dart';
import '../../../../../api_service/Constant.dart';
import '../../../../../api_service/app_cash.dart';
import '../../../../../common_controller/MiscController.dart';


class AttendanceHistoryRepository {

  API api = API();
  final _miscController = MiscController();

  //region fetchData
  Future fetchData({ required Function(bool isSuccess, String message, List<AttendanceHistory> dataList) onComplete}) async {
    List<AttendanceHistory> list = [];
    await _miscController.checkInternet().then((value) async {
      if (!value.contains('ignore')) {
        var apiResponse = await api.fetchListData(endpoint: "/my-attendance/" ,token: AppCache().userInfo?.token.toString());
        var success = jsonDecode(apiResponse)['Success'];
        var message = jsonDecode(apiResponse)['Message'];
        if (success) {
          try {
            var packetList = jsonDecode(apiResponse)['PacketList'];
            if(packetList!=null){
              list.clear();
              for (var item in packetList) {
                AttendanceHistory object = AttendanceHistory.fromJson(item);
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

  //region Filter
  filterByDate({required List<AttendanceHistory> datalist, required String date,required Function(bool isSuccess, String message, List<AttendanceHistory> dataList) onComplete} ){
    List<AttendanceHistory> list = datalist;

    List<AttendanceHistory> filteredList=list.where((items)=>items.date==date).toList();

    if (filteredList.isNotEmpty) {
      onComplete(true, "Data found", filteredList);
    } else {
      onComplete(false, "No data found for the given date", []);
    }
 }
  //endregion

}