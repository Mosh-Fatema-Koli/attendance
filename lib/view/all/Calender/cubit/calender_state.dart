import 'package:equatable/equatable.dart';

abstract class CalendarState extends Equatable {
  const CalendarState();

  @override
  List<Object> get props => [];
}

class CalendarInitial extends CalendarState {}

class CalendarLoaded extends CalendarState {
  final List<DateTime> holidays;

  const CalendarLoaded({required this.holidays});

  @override
  List<Object> get props => [holidays];
}
