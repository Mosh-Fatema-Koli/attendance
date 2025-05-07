
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../api_service/Constant.dart';
import '../../../../api_service/app_cash.dart';
import '../../../../common_controller/MiscController.dart';
import '../../../../common_model/UserInfo.dart';
import '../../Login/cubit/login_repoitory.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(SplashInitial(needLogin: false,success: false,message: "")){
    loginApiCall();
  }

  final _loginRepository = LoginRepository();
  final _miscController = MiscController();

  loginApiCall() async {
    SharedPreferences pref = await _miscController.pref();
    final userInfoString = _miscController.prefGetString(pref: pref, key: Constant.userInfoPref);
    UserInfo userInfo = (userInfoString != null && userInfoString.isNotEmpty)
        ? UserInfo.fromJson(jsonDecode(userInfoString))
        : UserInfo();
    userInfo = AppCache(userInfo: userInfo).userInfo!;
    String? username = userInfo.username;
    await _miscController.delayed(millisecond: 3000);
    if(username != null && username.isNotEmpty){
     emit(SplashInitial(needLogin: false, success: true, message: "message",));
    } else {
      emit(SplashInitial(needLogin: true, success: false, message: '', ));
    }
  }

}
