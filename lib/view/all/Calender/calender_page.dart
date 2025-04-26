import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../widgets/framework/rf_text.dart';
import 'comphonent/months_view.dart';
import 'cubit/calender_cubit.dart';
import 'cubit/calender_state.dart';

class CalenderPage extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();
  final double _monthViewHeight =
      400.0; // Adjust based on your MonthView height

  CalenderPage({Key? key}) : super(key: key);

  void _scrollToCurrentMonth() {
    final currentMonth = DateTime.now().month;
    final offset = (currentMonth - 1) * _monthViewHeight;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        offset,
        duration: Duration(seconds: 1),
        curve: Curves.easeInOut,

      );
    });
  }

  @override
  Widget build(BuildContext context) {
    _scrollToCurrentMonth();

    return BlocProvider(
      create: (context) => CalendarCubit(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          automaticallyImplyLeading: false,
          title:RFText(
            text: "Yearly Calender",
            size: 20.sp,
            color: Colors.white,
            weight: FontWeight.bold,
          ),
        ),
        body: BlocBuilder<CalendarCubit, CalendarState>(
          builder: (context, state) {
            if (state is CalendarLoaded) {
              return ListView.builder(
                controller: _scrollController,
                itemCount: 12,
                physics: AlwaysScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(15),
                    child: MonthView(
                      month: index + 1,
                      holidays: state.holidays,
                    ),
                  );
                },
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}




