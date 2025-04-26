import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../api_service/ApiController.dart';
import '../../../../api_service/app_cash.dart';
import '../../../../common_controller/MiscController.dart';
import '../../../../common_model/UserInfo.dart';

class Logout {

  API api = API();
  final _miscController = MiscController();

  //region logout
  Future logout({required BuildContext context, required Function onLogout}) async {
    if(context.mounted){
      await _miscController.showGraphicalDialog(
          context: context,
          cancelable: false,
          imagePath: 'assets/images/exit.png',
          title: 'Logout',
          subTitle: 'Do you want to logout now?',
          okText: 'Yes',
          okPressed: () async {
            Navigator.pop(context);
            _miscController.delayed(millisecond: 2000);
            _miscController.showProgressDialog(context: context);
            if(context.mounted){
              await finalLogOut(onOut: onLogout, context: context);
            }
          },
          cancelText: 'NO',
          cancelPressed: () {
            Navigator.pop(context);
          });
    }
  }
  //endregion

  //region final out
  Future finalLogOut({required BuildContext context, required Function onOut}) async {
    var apiResponse = await api.logout(endpoint: "/logout/" ,token: AppCache().userInfo?.token.toString());
    var success = jsonDecode(apiResponse)['Success'];
      SharedPreferences pref = await _miscController.pref();
      _miscController.prefRemoveAll(pref: pref);
      AppCache().userInfo = UserInfo();
      onOut();

  }
//endregion

}