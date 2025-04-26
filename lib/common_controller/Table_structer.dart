//
//
// import 'package:sqflite/sqflite.dart';
//
// class TableStructure {
//
//   Future<void> createMeetingRoomTable(Database db) async {
//     await db.execute('''
//     CREATE TABLE IF NOT EXISTS MeetingRoom (
//       FeedbackId TEXT primary key,
//       FeedbackDate TEXT,
//       FeedbackCategoryId INTEGER,
//       FeedbackSubCategoryId INTEGER,
//       FeedbackRecorder TEXT,
//       ProviderName TEXT,
//       ProviderTypeId INTEGER,
//       ProviderSpecialTypeId INTEGER,
//       FeedbackSourceId INTEGER,
//       FeedbackSourceOther TEXT,
//       ProviderPhone TEXT,
//       FeedbackDetails TEXT,
//       FeedbackDueDate TEXT,
//       InstantResolution INTEGER,
//       InstantResolutionRemarks TEXT,
//       FeedbackProviderAddress TEXT,
//       FeedbackStatus INTEGER,
//       ProjectId INTEGER,
//       ThemeId INTEGER,
//       ProgramId INTEGER,
//       PartnerId INTEGER,
//       DistrictCode TEXT,
//       UpazilaCode TEXT,
//       UnionCode TEXT,
//       VillageCode TEXT,
//       BlockId INTEGER,
//       CampId INTEGER,
//       FeedbackCloseDate TEXT,
//       MOHAId TEXT,
//       GFDId TEXT,
//       ScopeId TEXT,
//       FCNNo TEXT,
//       CommunityStatus INTEGER,
//       Status INTEGER,
//       DataCollectionDate TEXT,
//       DataCollectionTime TEXT,
//       UserId INTEGER,
//       Latitude TEXT,
//       Longitude TEXT,
//       DataStatus INTEGER,
//       ModifiedBy INTEGER,
//       ModificationDate TEXT,
//       IsVerified INTEGER,
//       VerifiedBy INTEGER,
//       VerificationDate TEXT,
//       VerificationNote TEXT
//     )
//   ''');
//   }
//
//   Future<void> createStuffListTable(Database db) async {
//     await db.execute('''
//     CREATE TABLE IF NOT EXISTS MeetingRoom (
//       FeedbackId TEXT primary key,
//       FeedbackDate TEXT,
//       FeedbackCategoryId INTEGER,
//       FeedbackSubCategoryId INTEGER,
//       FeedbackRecorder TEXT,
//       ProviderName TEXT,
//       ProviderTypeId INTEGER,
//       ProviderSpecialTypeId INTEGER,
//       FeedbackSourceId INTEGER,
//       FeedbackSourceOther TEXT,
//       ProviderPhone TEXT,
//       FeedbackDetails TEXT,
//       FeedbackDueDate TEXT,
//       InstantResolution INTEGER,
//       InstantResolutionRemarks TEXT,
//       FeedbackProviderAddress TEXT,
//       FeedbackStatus INTEGER,
//       ProjectId INTEGER,
//       ThemeId INTEGER,
//       ProgramId INTEGER,
//       PartnerId INTEGER,
//       DistrictCode TEXT,
//       UpazilaCode TEXT,
//       UnionCode TEXT,
//       VillageCode TEXT,
//       BlockId INTEGER,
//       CampId INTEGER,
//       FeedbackCloseDate TEXT,
//       MOHAId TEXT,
//       GFDId TEXT,
//       ScopeId TEXT,
//       FCNNo TEXT,
//       CommunityStatus INTEGER,
//       Status INTEGER,
//       DataCollectionDate TEXT,
//       DataCollectionTime TEXT,
//       UserId INTEGER,
//       Latitude TEXT,
//       Longitude TEXT,
//       DataStatus INTEGER,
//       ModifiedBy INTEGER,
//       ModificationDate TEXT,
//       IsVerified INTEGER,
//       VerifiedBy INTEGER,
//       VerificationDate TEXT,
//       VerificationNote TEXT
//     )
//   ''');
//   }
//
//   Future<void> createUserInfoTable(Database db) async {
//     await db.execute('''
//     CREATE TABLE IF NOT EXISTS UserInfo (
//       Id TEXT,
//       Email TEXT,
//       UserId INTEGER,
//       IsActive INTEGER,
//       FullName TEXT,
//       PhoneNumber TEXT,
//       Username TEXT,
//       Token TEXT,
//       Designation TEXT,
//       StaffID TEXT,
//       Organization TEXT,
//       Password TEXT
//     )
//   ''');
//   }
//
//
//
// }