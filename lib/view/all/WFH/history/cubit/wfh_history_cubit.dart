import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../../api_service/ApiController.dart';
import '../../../../../api_service/app_cash.dart';
import '../../../../../common_controller/MiscController.dart';
import 'wfh_Repository.dart';
import 'wfh_history_state.dart';

class WFHHistoryCubit extends Cubit<WFHHistoryState> {
  WFHHistoryCubit() : super( WFHHistoryInitial());

  final _repository = WFHRepository();
  final _miscController = MiscController();
  API api = API();

  void loadData({BuildContext? context}) {
    if (context != null) {
      _miscController.showProgressDialog(context: context);
    }

    _repository.fetchData(
      onComplete: (isSuccess, message, dataList) {
        if (context != null) {
          Navigator.pop(context);
        }
        emit(WFHHistoryLoadedState(
          success: isSuccess,
          message: message,
          listOfData: dataList,
        ));
      },
    );
  }


  Future<void> delete({
    required BuildContext context,
    required Function(bool isSuccess, String message) onComplete,
    required int id,
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
                endpoint: "/wfhapplication/$id/",
                token: AppCache().userInfo?.token.toString(),
                // ✅ Pass FormData directly
              );

              var response = jsonDecode(apiResponse);
              var success = response['Success'];
              var message = response['Packet']['message'];

              _miscController.navigateBack(context: context);

              if (success) {
                print("API Response: $response");
                _miscController.toast(msg: message,position: ToastGravity.TOP);
                loadData();
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
