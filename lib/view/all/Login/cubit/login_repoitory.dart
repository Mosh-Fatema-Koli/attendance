import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../api_service/ApiController.dart';
import '../../../../api_service/Constant.dart';
import '../../../../api_service/app_cash.dart';
import '../../../../common_controller/MiscController.dart';
import '../../../../common_model/UserInfo.dart';

class LoginRepository {

  API api = API();
  final _miscController = MiscController();

  //region LOGIN API
  Future login({required String username, required String password, required bool isOnlineApp, required bool isFromSplash, required Function(bool isSuccess, String message) onLoginResult}) async {
    await _miscController.checkInternet().then((value) async {
      if (!value.contains('ignore')) {
        var loginResponse = await api.login(username: username ?? '', password: password ?? '');
        var success = jsonDecode(loginResponse)['Success'];
        var message = jsonDecode(loginResponse)['Message'];
        if (success) {
          try {
            var packet = jsonDecode(loginResponse)['Packet'];
            UserInfo user = UserInfo.fromJson(packet);
            SharedPreferences preference = await _miscController.pref();
            _miscController.prefSetString(pref: preference, key: Constant.userInfoPref, value: userInfoToJson(user));
            AppCache(userInfo: user);
            onLoginResult(true, 'Login Success');
          } catch (ex) {
            onLoginResult(false, 'Login Error : ${ex.toString()}');
          }
        } else {
          onLoginResult(false, 'Login Error : $message');
        }
      } else {
        if(isOnlineApp){
          onLoginResult(false, "Internet Error!\nYou are offline, Please check your internet connection.");
        } else {
          if(isFromSplash){
            onLoginResult(true, '');
          } else {
            onLoginResult(false, "Internet Error!\nYou are offline, Please check your internet connection.");
          }
        }
      }
    });
  }
  //endregion


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
              await _finalLogOut(onOut: onLogout, context: context);
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
  Future _finalLogOut({required BuildContext context, required Function onOut}) async {
    SharedPreferences pref = await _miscController.pref();
    _miscController.prefRemoveAll(pref: pref);
    AppCache().userInfo = UserInfo();
    if(context.mounted) {
      Navigator.pop(context);
    }
    onOut();
  }
//endregion

}

