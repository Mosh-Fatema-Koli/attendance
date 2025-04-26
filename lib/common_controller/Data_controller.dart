//
//
// import 'dart:convert';
// import 'package:ondesk/common_controller/Repo_controller.dart';
// import 'MiscController.dart';
// import '../api_service/ApiController.dart';
// import 'UserGlobalInstance.dart';
//
// class DataController {
//
//   final _miscController = MiscController();
//   final _api = API();
//   final _repository = Repository();
//
//   Future<Map<String, dynamic>> addCommonValuesAndPK({required String primaryKey, required Map<String, dynamic> jsonMap})async {
//     jsonMap["Latitude"] = jsonMap["Latitude"] ?? '';
//     jsonMap["Longitude"] = jsonMap["Longitude"] ?? '';
//     jsonMap["IsVerified"] = jsonMap["IsVerified"] ?? 0;
//     jsonMap["VerifiedBy"] = jsonMap["VerifiedBy"] ?? 0;
//     jsonMap["VerificationDate"] = jsonMap["VerificationDate"] ?? '';
//     jsonMap["VerificationNote"] = jsonMap["VerificationNote"] ?? '';
//     jsonMap["ModificationDate"] = _miscController.getCurrentDate();
//     jsonMap["ModifiedBy"] = UserGlobalInstance.userInfo.userId;
//     if (jsonMap["DataCollectionDate"]==null || jsonMap["DataCollectionDate"].toString().isEmpty) {
//       jsonMap["DataCollectionDate"] = _miscController.getCurrentDate();
//     }
//     if (jsonMap["DataCollectionTime"]==null || jsonMap["DataCollectionTime"].toString().isEmpty) {
//       jsonMap["DataCollectionTime"] = _miscController.getCurrentTime();
//     }
//     if (jsonMap["UserId"] == null || jsonMap["UserId"].toString().isEmpty || jsonMap["UserId"].toString() == '0') {
//       jsonMap["UserId"] = UserGlobalInstance.userInfo.userId;
//     }
//     if (jsonMap["DataStatus"].toString() == '1' || jsonMap["DataStatus"].toString() == '2') {
//       jsonMap["DataStatus"] = 2;
//     } else {
//       jsonMap["DataStatus"] = 0;
//     }
//     if (jsonMap[primaryKey] == null || jsonMap[primaryKey].toString().isEmpty) {
//       jsonMap[primaryKey] = _miscController.getUniqueId();
//     }
//     return jsonMap;
//   }
//
//   Future<Map<String, dynamic>> clearPropertyValue({required Map<String, dynamic> jsonMap, required List<String> properties}) async {
//     for(String property in properties){
//       jsonMap[property] = null;
//     }
//     return jsonMap;
//   }
//
//   Future<String> checkValidation({required Map<String, dynamic> jsonMap, required List<String> properties}) async {
//     String warningMessage = ''; int serial = 0;
//     for(String property in properties){
//       String name = property; String warning = '';
//       if(property.contains('-')){
//         name = property.split('-').first;
//         warning = property.split('-').last;
//       }
//       if(jsonMap[name] == null || jsonMap[name]==""){
//         serial++;
//         if(warningMessage.isNotEmpty){
//           if(warning.isNotEmpty){
//             warningMessage = '$warningMessage, \n($serial) $warning';
//           } else {
//             warningMessage = '$warningMessage, \n($serial) $name';
//           }
//         } else {
//           if(warning.isNotEmpty){
//             warningMessage = '($serial) $warning';
//           } else {
//             warningMessage = '($serial) $name';
//           }
//         }
//       }
//     }
//     if(warningMessage.isNotEmpty){
//       warningMessage = 'Please provide following information : \n\n$warningMessage';
//     }
//     return warningMessage;
//   }
//
//   Future delete({required String tableName, String? where, List<Object?>? whereArgs}) async {
//     await _repository.delete(tableName: tableName, where: where, whereArgs: whereArgs);
//   }
//
//   Future add({required String tableName, required Map<String, dynamic> jsonMap}) async {
//     await _repository.insertData(tableName: tableName, object: jsonMap);
//   }
//
//   Future update({required String tableName, required String primaryKey, required Map<String, dynamic> jsonMap}) async {
//     await _repository.update(tableName: tableName, where: '$primaryKey = ?', whereArgs: ['${jsonMap[primaryKey]}'], object: jsonMap);
//   }
//
//   Future addOrUpdate({required String tableName, required String primaryKey, required Map<String, dynamic> jsonMap}) async {
//     await _repository.ifExist(tableName: tableName, where: '$primaryKey = ?', whereArgs: ['${jsonMap[primaryKey]}'])
//         ? await _repository.update(tableName: tableName, where: '$primaryKey = ?', whereArgs: ['${jsonMap[primaryKey]}'], object: jsonMap)
//         : await _repository.insertData(tableName: tableName, object: jsonMap);
//   }
//
//   Future draft({required String tableName, required String primaryKey, required Map<String, dynamic> jsonMap}) async {
//     Map<String, dynamic> map = await addCommonValuesAndPK(primaryKey: primaryKey, jsonMap: jsonMap);
//     await addOrUpdate(tableName: tableName, primaryKey: primaryKey, jsonMap: map);
//   }
//
//   Future<int> uploadList({required String httpAddress, required String token, required String tableName, required bool hasLocalDB, required String primaryKey, required List<Map<String, dynamic>> jsonMapList}) async {
//     int failedDataCount = 0;
//     for(Map<String, dynamic> mapItem in jsonMapList){
//       List<String> response = await upload(httpAddress: httpAddress, token: token, tableName: tableName, hasLocalDB: hasLocalDB, primaryKey: primaryKey, jsonMap: mapItem);
//       response.first == 'false' ? failedDataCount++ : null ;
//     }
//     return failedDataCount;
//   }
//
//   Future<List<String>> upload({required String httpAddress, required String token, required String tableName, required bool hasLocalDB, required String primaryKey, required Map<String, dynamic> jsonMap}) async {
//     Map<String, dynamic> map = await addCommonValuesAndPK(primaryKey: primaryKey, jsonMap: jsonMap);
//     var apiResponse = await _api.sync(httpAddress: httpAddress, token: token, modelName: tableName, jsonPacket: json.encode(map));
//     var success = jsonDecode(apiResponse)['Success'];
//     var message = jsonDecode(apiResponse)['Message'];
//     if (hasLocalDB) {
//       if (success) {
//         map['DataStatus'] = 1;
//         await addOrUpdate(tableName: tableName, primaryKey: primaryKey, jsonMap: map);
//       }
//     }
//     return [success ? 'true' : 'false', message];
//   }
//
//   Future<int> getDataCount({required String tableName, String? where}) async {
//     int count = 0;
//     count = await _repository.count(tableName: tableName, where: where);
//     return count;
//   }
//
// }