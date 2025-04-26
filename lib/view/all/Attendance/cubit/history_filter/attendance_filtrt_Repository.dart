

import 'dart:convert';
import '../../../../../api_service/ApiController.dart';
import '../../../../../api_service/app_cash.dart';
import '../../../../../common_controller/MiscController.dart';
import '../../model/attendance_filter.dart';


class AttendanceFilterRepository {

  API api = API();
  final _miscController = MiscController();


  //region Summary
  Future summaryData({ required Function(bool isSuccess, String message, MyAttendanceFilter data) onComplete,required String month,required String year}) async {
    MyAttendanceFilter totalCalculation = MyAttendanceFilter();
    await _miscController.checkInternet().then((value) async {
      Map<String, dynamic> mapData = {
        "lookup_month": month,
        "lookup_year": year,
      };
      if (!value.contains('ignore')) {
        var apiResponse = await api.postData(endpoint: "/employee-working-summary/" ,token: AppCache().userInfo?.token.toString(),data: mapData);
        var success = jsonDecode(apiResponse)['Success'];
        var message = jsonDecode(apiResponse)['Message'];
        if (success) {
          try {
            var packetList = jsonDecode(apiResponse)['Packet'];
            var totalCalculationJson = MyAttendanceFilter.fromJson(packetList);
            onComplete(true, 'Data downloaded successfully', totalCalculationJson,);

          } catch (ex) {
            onComplete(false, 'Data downloaded successfully',totalCalculation);

            onComplete(false, 'Download Error!\n${ex.toString()}',totalCalculation);
          }
        } else {
          onComplete(false,  'Download Error!\n$message',totalCalculation);
        }
      } else {
        onComplete(false, "Internet Error!\nYou are offline, Please check your internet connection.",totalCalculation);
      }
    });
  }
 //endregion
}