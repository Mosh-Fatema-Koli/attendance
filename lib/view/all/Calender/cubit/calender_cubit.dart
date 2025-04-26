

import 'package:flutter_bloc/flutter_bloc.dart';

import 'calender_state.dart';

class CalendarCubit extends Cubit<CalendarState> {
  CalendarCubit() : super(CalendarInitial()) {
    _loadCalendar();
  }

  void _loadCalendar() {
    emit(CalendarLoaded(holidays: _getHolidays()));
  }

  final List<String> monthNames = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  final List<String> weekDays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];


  List<DateTime> _getHolidays() {
    return [
      DateTime(2025, 1, 1),   // New Year's Day
      DateTime(2025, 2, 15),  // Shab e-Barat
      DateTime(2025, 2, 21),  // Language Martyrs' Day
      DateTime(2025, 3, 26),  // Independence Day
      DateTime(2025, 3, 27),  // Shab-e-Qadr
      DateTime(2025, 3, 28),  // Jumatul Bidah
      DateTime(2025, 3, 29),  // Eid ul-Fitr Holiday
      DateTime(2025, 3, 30),  // Eid ul-Fitr Holiday
      DateTime(2025, 3, 31),  // Eid ul-Fitr
      DateTime(2025, 4, 1),   // Eid ul-Fitr Holiday
      DateTime(2025, 4, 2),   // Eid ul-Fitr Holiday
      DateTime(2025, 4, 14),  // Bengali New Year
      DateTime(2025, 5, 1),   // May Day
      DateTime(2025, 5, 11),  // Buddha Purnima
      DateTime(2025, 6, 5),   // Eid ul-Adha Holiday
      DateTime(2025, 6, 6),   // Eid ul-Adha Holiday
      DateTime(2025, 6, 7),   // Eid ul-Adha
      DateTime(2025, 6, 8),   // Eid ul-Adha Holiday
      DateTime(2025, 6, 9),   // Eid ul-Adha Holiday
      DateTime(2025, 6, 10),  // Eid ul-Adha Holiday
      DateTime(2025, 7, 6),   // Ashura
      DateTime(2025, 8, 15),  // National Mourning Day
      DateTime(2025, 8, 16),  // Janmashtami
      DateTime(2025, 9, 5),   // Eid-e-Milad un-Nabi
      DateTime(2025, 10, 1),  // Durga Puja Holiday
      DateTime(2025, 10, 2),  // Durga Puja (Bijoya Dashami)
      DateTime(2025, 12, 16), // Victory Day
      DateTime(2025, 12, 25)  // Christmas Day
    ];
  }
}
