// To parse this JSON data, do
//
//     final dashboardModel = dashboardModelFromJson(jsonString);

import 'dart:convert';

DashboardModel dashboardModelFromJson(String str) => DashboardModel.fromJson(json.decode(str));

String dashboardModelToJson(DashboardModel data) => json.encode(data.toJson());

class DashboardModel {
  User? user;
  dynamic checkIn;
  dynamic checkOut;
  dynamic totalWorkingHours;
  String? checkInstatus;
  String? checkOutstatus;
  bool? entryExistingRecord;
  bool? exitExistingRecord;
  String? allowedRouterMac;
  List<CurrentMonthAttendance>? currentMonthAttendance;

  DashboardModel({
    this.user,
    this.checkIn,
    this.checkOut,
    this.totalWorkingHours,
    this.checkInstatus,
    this.checkOutstatus,
    this.entryExistingRecord,
    this.exitExistingRecord,
    this.allowedRouterMac,
    this.currentMonthAttendance,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) => DashboardModel(
    user: json["user"] == null ? null : User.fromJson(json["user"]),
    checkIn: json["check_in"],
    checkOut: json["check_out"],
    totalWorkingHours: json["total_working_hours"],
    checkInstatus: json["check_instatus"],
    checkOutstatus: json["check_outstatus"],
    entryExistingRecord: json["entry_existing_record"],
    exitExistingRecord: json["exit_existing_record"],
    allowedRouterMac: json["ALLOWED_ROUTER_MAC"],
    currentMonthAttendance: json["current_month_attendance"] == null ? [] : List<CurrentMonthAttendance>.from(json["current_month_attendance"]!.map((x) => CurrentMonthAttendance.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "user": user?.toJson(),
    "check_in": checkIn,
    "check_out": checkOut,
    "total_working_hours": totalWorkingHours,
    "check_instatus": checkInstatus,
    "check_outstatus": checkOutstatus,
    "entry_existing_record": entryExistingRecord,
    "exit_existing_record": exitExistingRecord,
    "ALLOWED_ROUTER_MAC": allowedRouterMac,
    "current_month_attendance": currentMonthAttendance == null ? [] : List<dynamic>.from(currentMonthAttendance!.map((x) => x.toJson())),
  };
}

class CurrentMonthAttendance {
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

  CurrentMonthAttendance({
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

  factory CurrentMonthAttendance.fromJson(Map<String, dynamic> json) => CurrentMonthAttendance(
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

class User {
  int? id;
  String? username;
  String? employeeId;
  String? name;
  String? role;
  String? designation;
  String? phone;
  String? email;
  String? address;
  String? dateOfBirth;
  String? joiningDate;
  String? image;

  User({
    this.id,
    this.username,
    this.employeeId,
    this.name,
    this.role,
    this.designation,
    this.phone,
    this.email,
    this.address,
    this.dateOfBirth,
    this.joiningDate,
    this.image,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    username: json["username"],
    employeeId: json["employee_id"],
    name: json["name"],
    role: json["role"],
    designation: json["designation"],
    phone: json["phone"],
    email: json["email"],
    address: json["address"],
    dateOfBirth: json["date_of_birth"],
    joiningDate: json["joining_date"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "employee_id": employeeId,
    "name": name,
    "role": role,
    "designation": designation,
    "phone": phone,
    "email": email,
    "address": address,
    "date_of_birth": dateOfBirth,
    "joining_date": joiningDate,
    "image": image,
  };
}
