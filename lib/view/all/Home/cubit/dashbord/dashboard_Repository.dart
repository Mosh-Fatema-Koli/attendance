

import 'dart:convert';
import 'package:attendance/view/all/Login/login_page.dart';
import 'package:flutter/cupertino.dart';

import '../../../../../api_service/ApiController.dart';
import '../../../../../api_service/app_cash.dart';
import '../../../../../common_controller/MiscController.dart';
import '../../../Login/cubit/logout.dart';
import '../../model/dashboard_model.dart';


class DashboardRepository {

  API api = API();
  final logoutController = Logout();
  final _miscController = MiscController();

  //region fetchData
  Future fetchData( {required Function(bool isSuccess, String message, DashboardModel? dashboard) onComplete}) async {
    DashboardModel  dashboard = DashboardModel();
    await _miscController.checkInternet().then((value) async {

      if (!value.contains('ignore')) {
        var apiResponse = await api.fetchData(endpoint: "/dashboard/" ,token: AppCache().userInfo?.token.toString());
        var success = jsonDecode(apiResponse)['Success'];
        var message = jsonDecode(apiResponse)['Message'];
        if (success) {
          try {
            var list = jsonDecode(apiResponse)['PacketList'];
            var dashboardData = DashboardModel.fromJson(list);
              onComplete(true, 'Data downloaded successfully',  dashboardData);

          } catch (ex) {

            onComplete(false, 'Download Error!\n${ex.toString()}',dashboard);
          }
        } else {
        //  _miscController.toast(msg: "Internet Error!!\nYou are offline, Please check your internet connection.");
          onComplete(false,  'Download Error!\n$message',dashboard);
        }
      } else {
        _miscController.toast(msg: "Internet Error!!\nYou are offline, Please check your internet connection.");
        onComplete(false, "Internet Error!\nYou are offline, Please check your internet connection.",dashboard);
      }
    });
  }
//endregion

}