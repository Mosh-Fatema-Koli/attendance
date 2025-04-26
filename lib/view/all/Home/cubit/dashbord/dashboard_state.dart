part of 'dashboard_cubit.dart';

abstract class DashboardState {
  bool success=false;
  String message="";
  DashboardModel dashboard=DashboardModel();

  @override
  List<Object> get props => [success, message,dashboard];

}

final class DashboardInitial extends DashboardState {}

final class DashboardLoadedState extends DashboardState {
  DashboardLoadedState({DashboardModel? dashboard,bool? success, String? message, }) {
    this.success = success ?? this.success;
    this.message = message ?? this.message;
    this.dashboard = dashboard ?? this.dashboard;
  }

}