// To parse this JSON data, do
//
//     final attendanceHistory = attendanceHistoryFromJson(jsonString);

import 'dart:convert';

AttendanceHistory attendanceHistoryFromJson(String str) => AttendanceHistory.fromJson(json.decode(str));

String attendanceHistoryToJson(AttendanceHistory data) => json.encode(data.toJson());

class AttendanceHistory {
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
  dynamic earlyHours;

  AttendanceHistory({
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

  factory AttendanceHistory.fromJson(Map<String, dynamic> json) => AttendanceHistory(
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
