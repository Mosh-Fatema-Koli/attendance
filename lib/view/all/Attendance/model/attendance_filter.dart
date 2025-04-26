import 'dart:convert';

MyAttendanceFilter myAttendanceFilterFromJson(String str) => MyAttendanceFilter.fromJson(json.decode(str));

String myAttendanceFilterToJson(MyAttendanceFilter data) => json.encode(data.toJson());

class MyAttendanceFilter {
  List<MonthAttendanceSummary>? monthAttendanceSummary;
  double? totalHours;
  double? totalLessMoreHours;
  double? totalLateHours;
  double? totalEarlyHours;
  int? totalPresent;
  int? totalAbsent;
  int? totalLate;
  int? totalEarly;
  String? lookupMonth;
  String? lookupYear;

  MyAttendanceFilter({
    this.monthAttendanceSummary,
    this.totalHours,
    this.totalLessMoreHours,
    this.totalLateHours,
    this.totalEarlyHours,
    this.totalPresent,
    this.totalAbsent,
    this.totalLate,
    this.totalEarly,
    this.lookupMonth,
    this.lookupYear,
  });

  factory MyAttendanceFilter.fromJson(Map<String, dynamic> json) => MyAttendanceFilter(
    monthAttendanceSummary: json["month_attendance_summary"] == null ? [] : List<MonthAttendanceSummary>.from(json["month_attendance_summary"]!.map((x) => MonthAttendanceSummary.fromJson(x))),
    totalHours: json["total_hours"]?.toDouble(),
    totalLessMoreHours: json["total_less_more_hours"]?.toDouble(),
    totalLateHours: json["total_late_hours"]?.toDouble(),
    totalEarlyHours: json["total_early_hours"]?.toDouble(),
    totalPresent: json["total_present"],
    totalAbsent: json["total_absent"],
    totalLate: json["total_late"],
    totalEarly: json["total_early"],
    lookupMonth: json["lookup_month"],
    lookupYear: json["lookup_year"],
  );

  Map<String, dynamic> toJson() => {
    "month_attendance_summary": monthAttendanceSummary == null ? [] : List<dynamic>.from(monthAttendanceSummary!.map((x) => x.toJson())),
    "total_hours": totalHours,
    "total_less_more_hours": totalLessMoreHours,
    "total_late_hours": totalLateHours,
    "total_early_hours": totalEarlyHours,
    "total_present": totalPresent,
    "total_absent": totalAbsent,
    "total_late": totalLate,
    "total_early": totalEarly,
    "lookup_month": lookupMonth,
    "lookup_year": lookupYear,
  };
}

class MonthAttendanceSummary {
  int? id;
  String? date;
  String? day;
  String? checkIn;
  String? checkOut;
  String? status;
  String? totalWorkingHours;
  String? lessMoreHours;
  String? checkInstatus;
  String? checkOutstatus;
  String? lateHours;
  String? earlyHours;

  MonthAttendanceSummary({
    this.id,
    this.date,
    this.day,
    this.checkIn,
    this.checkOut,
    this.status,
    this.totalWorkingHours,
    this.lessMoreHours,
    this.checkInstatus,
    this.checkOutstatus,
    this.lateHours,
    this.earlyHours,
  });

  factory MonthAttendanceSummary.fromJson(Map<String, dynamic> json) => MonthAttendanceSummary(
    id: json["id"],
    date: json["date"],
    day: json["day"],
    checkIn: json["check_in"],
    checkOut: json["check_out"],
    status: json["status"],
    totalWorkingHours: json["total_working_hours"],
    lessMoreHours: json["less_more_hours"],
    checkInstatus: json["check_instatus"],
    checkOutstatus: json["check_outstatus"],
    lateHours: json["late_hours"],
    earlyHours: json["early_hours"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "date": date,
    "day": day,
    "check_in": checkIn,
    "check_out": checkOut,
    "status": status,
    "total_working_hours": totalWorkingHours,
    "less_more_hours": lessMoreHours,
    "check_instatus": checkInstatus,
    "check_outstatus": checkOutstatus,
    "late_hours": lateHours,
    "early_hours": earlyHours,
  };
}
