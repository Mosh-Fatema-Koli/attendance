
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../common_controller/MiscController.dart';
import '../../model/dashboard_model.dart';
import '../../model/total_calculation.dart';
import 'dashboard_Repository.dart';

part 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit() : super(DashboardInitial());

  final _repository = DashboardRepository();
  final _miscController = MiscController();

  loadData({BuildContext? context}) {
    if(context != null){
      _miscController.showProgressDialog(context: context);
    }
    _repository.fetchData(
      onComplete: (isSuccess, message,dashboard) {
        if(context != null){
          Navigator.pop(context);
        }
        emit(DashboardLoadedState(success: isSuccess, message: message,dashboard: dashboard));
      },);
  }
}

