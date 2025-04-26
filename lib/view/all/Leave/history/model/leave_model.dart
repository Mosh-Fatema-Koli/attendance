

import 'dart:convert';

LeaveModel leaveModelFromJson(String str) => LeaveModel.fromJson(json.decode(str));

String leaveModelToJson(LeaveModel data) => json.encode(data.toJson());

class LeaveModel {
  int? id;
  int? employee;
  String? leaveTypes;
  String? startDate;
  String? endDate;
  int? totalDays;
  String? reason;
  String? status;
  String? image;
  String? createdAt;

  LeaveModel({
    this.id,
    this.employee,
    this.leaveTypes,
    this.startDate,
    this.endDate,
    this.totalDays,
    this.reason,
    this.status,
    this.image,
    this.createdAt,
  });

  factory LeaveModel.fromJson(Map<String, dynamic> json) => LeaveModel(
    id: json["id"],
    employee: json["employee"],
    leaveTypes: json["leave_types"],
    startDate: json["start_date"],
    endDate: json["end_date"],
    totalDays: json["total_days"],
    reason: json["reason"],
    status: json["status"],
    image: json["image"]?.replaceAll('\n', '').replaceAll(' ', '').trim(),
    createdAt: json["created_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "employee": employee,
    "leave_types": leaveTypes,
    "start_date": startDate,
    "end_date": endDate,
    "total_days": totalDays,
    "reason": reason,
    "status": status,
    "image": image,
    "created_at": createdAt,
  };
}
