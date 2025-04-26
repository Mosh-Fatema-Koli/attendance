//
// import 'package:ondesk/common_controller/Table_structer.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';
// import 'dart:io' as io;
// import '../api_service/Constant.dart';
//
// class Repository {
//
//   static Database? _database;
//
//   Future<Database?> get database async {
//     if (_database != null) return _database;
//     _database = await initDatabase();
//     return _database;
//   }
//
//   initDatabase() async {
//     io.Directory documentDirectory = await getApplicationDocumentsDirectory();
//     String path = join(documentDirectory.path, Constant.databaseName);
//     var db = await openDatabase(path,
//         version: 1, onCreate: _createDB, onUpgrade: null);
//     return db;
//   }
//
//   _createDB(Database db, int version) async {
//     TableStructure tableStructure = TableStructure();
//     tableStructure.createUserInfoTable(db);
//     tableStructure.createMeetingRoomTable(db);
//     tableStructure.createStuffListTable(db);
//
//   }
//
//   Future<void> insertData ({required tableName, required Map<String, dynamic> object}) async {
//     try {
//       final db = await database;
//       db!.insert(tableName, object);
//     } catch (e) {
//       print('database insertion failed: ${e.toString()}');
//     }
//   }
//
//   Future<void> update({required tableName, required String where, required List<Object?> whereArgs, required Map<String, dynamic> object}) async {
//     try {
//       final db = await database;
//       await db!.update(tableName, object, where: where, whereArgs: whereArgs);
//     } catch (e) {
//       print('database update failed: ${e.toString()}');
//     }
//   }
//
//   Future<void> delete({required tableName, String? where, List<Object?>? whereArgs}) async {
//     try {
//       final db = await database;
//       await db!.delete(tableName, where: where, whereArgs: whereArgs);
//     } catch (e) {
//       print('database delete failed: ${e.toString()}');
//     }
//   }
//
//   Future<void> deleteSql(String rawSql) async {
//     try {
//       final db = await database;
//       db!.rawDelete(rawSql);
//     } catch (e) {
//       print('database delete failed: ${e.toString()}');
//     }
//   }
//
//   Future<List<T>> getAllData<T>({required String tableName, required T Function(Map<String, dynamic>) fromJson,
//     bool? distinct, List<String>? columns, String? where, List<Object?>? whereArgs, String? groupBy, String? having,
//     String? orderBy, int? limit, int? offset}) async {
//     List<T> list = [];
//     try {
//       final db = await database;
//       final result = await db?.query(tableName, distinct: distinct, columns: columns, where: where, whereArgs: whereArgs,
//           groupBy: groupBy, having: having, orderBy: orderBy, limit: limit, offset: offset);
//       result != null && result.isNotEmpty ? list = result.map((json) => fromJson(json)).toList() : [];
//     } catch (e) {
//       print('database get failed: ${e.toString()}');
//     }
//     return list;
//   }
//
//   Future<List<T>> getAllDataSql<T>({required String rawQuery, required T Function(Map<String, dynamic>) fromJson}) async {
//     List<T> list = [];
//     try {
//       final db = await database;
//       final result = await db?.rawQuery(rawQuery);
//       result != null && result.isNotEmpty ? list = result.map((json) => fromJson(json)).toList() : [];
//     } catch (e) {
//       print('database get failed: ${e.toString()}');
//     }
//     return list;
//   }
//
//   Future<bool> ifExist({required String tableName, required String where, required List<Object?> whereArgs}) async {
//     bool ifExist = false;
//     try {
//       final db = await database;
//       final result = await db?.query(tableName, where: where, whereArgs: whereArgs);
//       result != null && result.isNotEmpty ? ifExist = true : false;
//     } catch (e) {
//       print('database query failed: ${e.toString()}');
//     }
//     return ifExist;
//   }
//
//   Future<int> count({required String tableName, String? where}) async {
//     int count = 0;
//     try {
//       final db = await database;
//       var result = await db?.rawQuery('SELECT COUNT (*) from $tableName ${where??''}');
//       count = Sqflite.firstIntValue(result!) ?? 0;
//     } catch (e) {
//       print('database count query failed: ${e.toString()}');
//     }
//     return count;
//   }
//
// }