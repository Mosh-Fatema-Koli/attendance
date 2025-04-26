
import 'dart:convert';

MyAttendance myattendanceFromJson(String str) => MyAttendance.fromJson(json.decode(str));

String myattendanceToJson(MyAttendance data) => json.encode(data.toJson());

class MyAttendance {
  int? id;
  String? date;
  String? entryTime;
  String? exitTime;
  String? status;
  String? totalWorkingHours;
  String? lessMoreHours;
  String? late;
  String? early;
  String? lateHours;
  String? earlyHours;

  MyAttendance({
    this.id,
    this.date,
    this.entryTime,
    this.exitTime,
    this.status,
    this.totalWorkingHours,
    this.lessMoreHours,
    this.late,
    this.early,
    this.lateHours,
    this.earlyHours,
  });

  factory MyAttendance.fromJson(Map<String, dynamic> json) => MyAttendance(
    id: json["id"],
    date: json["date"],
    entryTime: json["entry_time"],
    exitTime: json["exit_time"],
    status: json["status"],
    totalWorkingHours: json["total_working_hours"],
    lessMoreHours: json["less_more_hours"],
    late: json["late"],
    early: json["early"],
    lateHours: json["late_hours"],
    earlyHours: json["early_hours"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "date": date,
    "entry_time": entryTime,
    "exit_time": exitTime,
    "status": status,
    "total_working_hours": totalWorkingHours,
    "less_more_hours": lessMoreHours,
    "late": late,
    "early": early,
    "late_hours": lateHours,
    "early_hours": earlyHours,
  };
}
