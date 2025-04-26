import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../api_service/colors.dart';
import '../cubit/calender_cubit.dart';

class MonthView extends StatelessWidget {
  final int month;
  final List<DateTime> holidays;

  MonthView({required this.month, required this.holidays});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final daysInMonth = DateUtils.getDaysInMonth(now.year, month);
    final firstDayOfMonth = DateTime(now.year, month, 1);
    final startingWeekday =
        firstDayOfMonth.weekday % 7; // Adjust for 0-based index (Sunday = 0)

    return BlocProvider(
      create: (context) => CalendarCubit(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 5,
          ),
          Center(
            child: Text(
              context.read<CalendarCubit>().monthNames[month - 1],
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: context
                .read<CalendarCubit>()
                .weekDays
                .map((day) => Expanded(
              child: Center(
                child: Text(day,
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ))
                .toList(),
          ),
          SizedBox(
            height: 5,
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7, mainAxisSpacing: 5),
            itemCount: daysInMonth + startingWeekday,
            itemBuilder: (context, index) {
              if (index < startingWeekday) {
                return Container(); // Empty cells for the starting weekday offset
              }
              final day =
              DateTime(now.year, month, index - startingWeekday + 1);
              final isHoliday = holidays.any((holiday) =>
              holiday.month == month &&
                  holiday.day == index - startingWeekday + 1);
              final isWeekend = day.weekday == DateTime.friday;
              return Container(
                margin: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(color: Colors.grey),
                  color: isHoliday || isWeekend
                      ? Colors.amberAccent
                      : Colors.white,
                ),
                child: Center(
                  child: Text(
                    '${index - startingWeekday + 1}',
                    style: TextStyle(
                      color:
                      isHoliday || isWeekend ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}