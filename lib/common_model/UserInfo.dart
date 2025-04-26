
import 'dart:convert';

UserInfo userInfoFromJson(String str) => UserInfo.fromJson(json.decode(str));

String userInfoToJson(UserInfo data) => json.encode(data.toJson());

class UserInfo {
  int? id;
  String? username;
  String? employeeId;
  String? name;
  String? role;
  String? designation;
  String? phone;
  String? email;
  String? address;
  String? joiningDate;
  String? image;
  String? token;

  UserInfo({
    this.id,
    this.username,
    this.employeeId,
    this.name,
    this.role,
    this.designation,
    this.phone,
    this.email,
    this.address,
    this.joiningDate,
    this.image,
    this.token,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) => UserInfo(
    id: json["id"],
    username: json["username"],
    employeeId: json["employee_id"],
    name: json["name"],
    role: json["role"],
    designation: json["designation"],
    phone: json["phone"],
    email: json["email"],
    address: json["address"],
    joiningDate: json["joining_date"],
    image: json["image"],
    token: json["token"],
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
    "joining_date": joiningDate,
    "image": image,
    "token": token,
  };
}
