
import 'dart:convert';

List<ModelDefault> modelDefaultFromJson(String str) => List<ModelDefault>.from(json.decode(str).map((x) => ModelDefault.fromJson(x)));

String modelDefaultToJson(List<ModelDefault> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ModelDefault {
  int? modelDefaultId;
  int? parentId;
  String? modelInfoName;
  String? fieldName;
  String? optionText;
  int? optionValue;
  int? optionOrder;

  ModelDefault({
    this.modelDefaultId,
    this.parentId,
    this.modelInfoName,
    this.fieldName,
    this.optionText,
    this.optionValue,
    this.optionOrder,
  });

  factory ModelDefault.fromJson(Map<String, dynamic> json) => ModelDefault(
    modelDefaultId: json["ModelDefaultId"],
    parentId: json["ParentId"],
    modelInfoName: json["ModelInfoName"],
    fieldName: json["FieldName"],
    optionText: json["OptionText"],
    optionValue: json["OptionValue"],
    optionOrder: json["OptionOrder"],
  );

  Map<String, dynamic> toJson() => {
    "ModelDefaultId": modelDefaultId,
    "ParentId": parentId,
    "ModelInfoName": modelInfoName,
    "FieldName": fieldName,
    "OptionText": optionText,
    "OptionValue": optionValue,
    "OptionOrder": optionOrder,
  };
}
