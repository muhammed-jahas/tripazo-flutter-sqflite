import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const dbName = 'triplineDatabase.db';
  static const dbVersion = 1;
  //User
  static const dbTable = 'triplineTable';
  static const columnId = 'id';
  static const columnUser = 'userName';
  static const columnPass = 'userPass';
  static const columnCPass = 'userConfirmPass';
  static const columnEmail = 'userEmail';
  static const columnProfile = 'userprofile';
  static const columnLoggedIn = 'loggedIn';
  //Trips
  static const tripsTable = 'tripsTable';
  static const columnTripId = 'tripId';

  static const columnTripName = 'tripName';
  static const columnTripDestination = 'tripDestination';
  static const columnTripStartDate = 'tripStartDate';
  static const columnTripEndDate = 'tripEndDate';
  static const columnTripType = 'tripType';
  static const columnTripTransporatation = 'tripTransporatation';

  static const columnTripCover = 'tripCover';
  static const columnTripStartLocation = 'tripStartLocation';
  static const columnTripBudget= 'tripBudget';

  //Checkpoints
  static const checkPointsTable = 'checkPointsTable';
  static const checkPointsId = 'checkPointsId';
  static const columnTripCheckpoint = 'tripCheckpoint';

  //Activities
  static const ActivitiesTable = 'activitiesTable';
  static const ActivitiesId = 'activitiesId';
  static const columnTripActivity = 'tripActivity';

  static const columnTripCompanions = 'tripCompanions';

  static const columnTripNotes = 'tripNotes';



  static Database? _database;
  static final DatabaseHelper instance = DatabaseHelper._();

  DatabaseHelper._();

  Future<Database> get database async {
    _database ??= await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, dbName);

    return await openDatabase(
      path,
      version: dbVersion,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $dbTable (
        $columnId INTEGER PRIMARY KEY,
        $columnUser TEXT NOT NULL,
        $columnPass TEXT NOT NULL,
        $columnCPass TEXT NOT NULL,
        $columnEmail TEXT NOT NULL,
        $columnProfile TEXT NOT NULL,
        $columnLoggedIn INTEGER DEFAULT 0
      )
    ''');
    await db.execute('''
    CREATE TABLE $tripsTable (
      $columnTripId INTEGER PRIMARY KEY,
      $columnId INTEGER,
      $columnTripName TEXT NOT NULL,
      $columnTripDestination TEXT NOT NULL,
      $columnTripStartDate TEXT NOT NULL,
      $columnTripEndDate TEXT NOT NULL,
      FOREIGN KEY ($columnId) REFERENCES $dbTable($columnId)
    )
  ''');
  await db.execute('''
    CREATE TABLE $checkPointsTable (
      $checkPointsId INTEGER PRIMARY KEY,
      $columnId INTEGER,
      $columnTripCheckpoint TEXT NOT NULL,
      FOREIGN KEY ($columnId) REFERENCES $tripsTable($columnTripId)
    )
  ''');
  await db.execute('''
    CREATE TABLE $ActivitiesTable (
      $ActivitiesId INTEGER PRIMARY KEY,
      $columnId INTEGER,
      $columnTripActivity TEXT NOT NULL,
      FOREIGN KEY ($columnId) REFERENCES $dbTable($columnTripId)
    )
  ''');
  }


  //Users Functions
  Future<int> insertRecord(Map<String, dynamic> row) async {
    Database db = await database;
    return await db.insert(dbTable, row);
  }

  Future<List<Map<String, dynamic>>> queryDatabase() async {
    Database db = await database;
    return await db.query(dbTable);
  }

  Future<int> updateRecord(Map<String, dynamic> row) async {
    Database db = await database;
    int id = row[columnId];
    return await db.update(
      dbTable,
      row,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteRecord(int id) async {
    Database? db = await database;
    return await db.delete(
      dbTable,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  Future<bool> isUsernameExists(String username) async {
    Database db = await database;
    List<Map<String, dynamic>> result = await db.query(
      dbTable,
      where: '$columnUser = ?',
      whereArgs: [username],
    );
    return result.isNotEmpty;
  }

  Future<bool> validateUserCredentials(String username, String password) async {
    Database db = await database;
    List<Map<String, dynamic>> result = await db.query(
      dbTable,
      where: '$columnUser = ? AND $columnPass = ?',
      whereArgs: [username, password],
    );
    return result.isNotEmpty;
  }

  Future<Map<String, dynamic>> getUserDataByUsername(String username) async {
    Database db = await database;
    List<Map<String, dynamic>> result = await db.query(
      dbTable,
      where: '$columnUser = ?',
      whereArgs: [username],
      limit: 1,
    );
    if (result.isNotEmpty) {
      return result[0];
    } else {
      return {}; // Return an empty map if no user data found
    }
  }

  Future<void> setLoggedInUser(Map<String, dynamic> userData) async {
    Database db = await database;

    // Clear the loggedIn status of existing users
    await db.update(
      dbTable,
      {columnLoggedIn: 0},
    );

    int id = userData[columnId];

    // Set the loggedIn status of the current user to 1
    await db.update(
      dbTable,
      {columnLoggedIn: 1},
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  Future<bool> checkLoggedIn() async {
    Database db = await database;
    List<Map<String, dynamic>> result = await db.query(
      dbTable,
      where: '$columnLoggedIn = ?',
      whereArgs: [1],
    );
    return result.isNotEmpty;
  }

  Future<Map<String, dynamic>> getLoggedInUserData() async {
    Database db = await database;
    List<Map<String, dynamic>> result = await db.query(
      dbTable,
      where: '$columnLoggedIn = ?',
      whereArgs: [1],
      limit: 1,
    );
    if (result.isNotEmpty) {
      return result[0];
    } else {
      return {}; // Return an empty map if no logged-in user data found
    }
  }

  Future<void> signOut() async {
    Database db = await database;

    // Get the logged-in user data
    Map<String, dynamic> loggedInUserData = await getLoggedInUserData();

    if (loggedInUserData.isNotEmpty) {
      int id = loggedInUserData[columnId];

      // Update the loggedIn status to 0
      await db.update(
        dbTable,
        {columnLoggedIn: 0},
        where: '$columnId = ?',
        whereArgs: [id],
      );
    }
  }



  //Trips Functions
  Future<int> insertTripRecord(Map<String, dynamic> row) async {
    Database db = await database;
    return await db.insert(tripsTable, row);
  }

  Future<List<Map<String, dynamic>>> queryTripRecord() async {
    Database db = await database;
    return await db.query(tripsTable);
  }

  Future<int> updateTripRecord(Map<String, dynamic> row) async {
    Database db = await database;
    int id = row[columnId];
    return await db.update(
      tripsTable,
      row,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteTripRecord(int id) async {
    Database? db = await database;
    return await db.delete(
      tripsTable,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  //Checkpoints Functions
  Future<int> insertCheckpointRecord(Map<String, dynamic> row) async {
    Database db = await database;
    return await db.insert(checkPointsTable, row);
  }

  Future<List<Map<String, dynamic>>> queryCheckpointRecord() async {
    Database db = await database;
    return await db.query(checkPointsTable);
  }

  Future<int> updateCheckpointRecord(Map<String, dynamic> row) async {
    Database db = await database;
    int id = row[columnId];
    return await db.update(
      checkPointsTable,
      row,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteCheckpointRecord(int id) async {
    Database? db = await database;
    return await db.delete(
      checkPointsTable,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

}
