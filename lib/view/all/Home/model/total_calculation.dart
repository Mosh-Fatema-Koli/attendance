
import 'dart:convert';

TotalCalculateAttendance totalCalculateAttendanceFromJson(String str) => TotalCalculateAttendance.fromJson(json.decode(str));

String totalCalculateAttendanceToJson(TotalCalculateAttendance data) => json.encode(data.toJson());

class TotalCalculateAttendance {
  double? totalWorkingHoursResult;
  double? totalLessMoreHoursResult;
  double? totalLateHours;
  double? totalEarlyHours;
  int? totalLate;
  int? totalEarly;
  int? totalPresent;
  int? totalAbsent;

  TotalCalculateAttendance({
    this.totalWorkingHoursResult,
    this.totalLessMoreHoursResult,
    this.totalLateHours,
    this.totalEarlyHours,
    this.totalLate,
    this.totalEarly,
    this.totalPresent,
    this.totalAbsent,
  });

  factory TotalCalculateAttendance.fromJson(Map<String, dynamic> json) => TotalCalculateAttendance(
    totalWorkingHoursResult: json["total_working_hours_result"]?.toDouble(),
    totalLessMoreHoursResult: json["total_less_more_hours_result"]?.toDouble(),
    totalLateHours: json["total_late_hours"]?.toDouble(),
    totalEarlyHours: json["total_early_hours"]?.toDouble(),
    totalLate: json["total_late"],
    totalEarly: json["total_early"],
    totalPresent: json["total_present"],
    totalAbsent: json["total_absent"],
  );

  Map<String, dynamic> toJson() => {
    "total_working_hours_result": totalWorkingHoursResult,
    "total_less_more_hours_result": totalLessMoreHoursResult,
    "total_late_hours": totalLateHours,
    "total_early_hours": totalEarlyHours,
    "total_late": totalLate,
    "total_early": totalEarly,
    "total_present": totalPresent,
    "total_absent": totalAbsent,
  };
}
