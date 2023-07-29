import 'dart:io';

import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const dbName = 'triplineDatabase.db';
  static const dbVersion = 1;
  //User
  static const usersTable = 'usersTable';
  static const columnUserId = 'userId';
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
  static const columnTripBudget = 'tripBudget';

  //Checkpoints
  static const checkPointsTable = 'checkPointsTable';
  static const columnCheckPointsId = 'checkPointsId';
  static const columnTripCheckpoint = 'tripCheckpoint';

  //Activities
  static const ActivitiesTable = 'activitiesTable';
  static const columnActivitiesId = 'activitiesId';
  static const columnTripActivity = 'tripActivity';

  static const columnTripCompanions = 'tripCompanions';

  static const columnTripNotes = 'tripNotes';
  //album
  static const AlbumTable = 'albumTable';
  static const columnAlbumId = 'albumId';
  static const ColumnAlbumImage = 'albumImage';

  //Expense Overview
  static const ExpenseTable = 'expenseTable';
  static const columnTripExpenseId = 'expenseId';
  static const columnTripBalance = 'tripBalance';
  static const columnExpenseTotal = 'tripExpenseTotal';
  static const columnExpensePerPerson = 'tripExpensePerPerson';
  static const columnExpenseCount = 'tripExpenseCount';

  //Expense Item
  static const ExpenseItemTable = 'expenseItemTable';
  static const columnTripExpenseItemId = 'expenseItemId';
  static const columnTripExpenseItemAmount = 'expenseItemAmount';
  static const columnTripExpenseItemKeyNote = 'expenseItemKeyNote';
  static const columnTripExpenseItemCategory = 'expenseItemCategory';
  static const columnTripExpenseItemDate = 'expenseItemDate';
  static const columnTripExpenseItemTime = 'expenseItemTime';

  static Database? _database;
  static final DatabaseHelper instance = DatabaseHelper._();

  DatabaseHelper._();

  Future<Database> get database async {
    _database ??= await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    try {
      Directory appDirectory = await getApplicationSupportDirectory();
      String path = join(appDirectory.path, 'databases', dbName);

      if (!await Directory(dirname(path)).exists()) {
        await Directory(dirname(path)).create(recursive: true);
      }

      return await openDatabase(
        path,
        version: dbVersion,
        onCreate: _createDB,

        onConfigure: (Database db) async {
          await db.execute('PRAGMA foreign_keys= ON;');
        }, //Foreign Keys Control
      );
    } catch (e) {
      print('Error initializing database: $e');
      rethrow; // Rethrow the error to propagate it further if needed
    }
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $usersTable (
        $columnUserId INTEGER PRIMARY KEY,
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
      $columnUserId INTEGER,
      $columnTripName TEXT,
      $columnTripDestination TEXT,
      $columnTripStartDate TEXT,
      $columnTripEndDate TEXT,
      $columnTripType TEXT,
      $columnTripTransporatation INTEGER,
      $columnTripCover TEXT,
      $columnTripStartLocation TEXT,
      $columnTripBudget INTEGER,
      $columnTripCompanions INTEGER,
      $columnTripNotes TEXT,
      FOREIGN KEY ($columnUserId) REFERENCES $usersTable($columnUserId) ON DELETE CASCADE
    )
  ''');
    await db.execute('''
    CREATE TABLE $checkPointsTable (
      $columnCheckPointsId INTEGER PRIMARY KEY,
      $columnTripId  INTEGER,
      $columnTripCheckpoint TEXT,
      FOREIGN KEY ($columnTripId) REFERENCES $tripsTable($columnTripId) ON DELETE CASCADE
    )
  ''');
    await db.execute('''
    CREATE TABLE $ActivitiesTable (
      $columnActivitiesId INTEGER PRIMARY KEY,
      $columnTripId  INTEGER,
      $columnTripActivity TEXT,
      FOREIGN KEY ($columnTripId) REFERENCES $tripsTable($columnTripId) ON DELETE CASCADE
    )
  ''');
    await db.execute('''
    CREATE TABLE $AlbumTable (
      $columnAlbumId INTEGER PRIMARY KEY,
      $columnTripId  INTEGER,
      $ColumnAlbumImage TEXT,
      FOREIGN KEY ($columnTripId) REFERENCES $tripsTable($columnTripId) ON DELETE CASCADE
    )
  ''');
    await db.execute('''
CREATE TABLE $ExpenseTable (
  $columnTripExpenseId INTEGER PRIMARY KEY,
  $columnTripId INTEGER,
  $columnTripBalance INTEGER DEFAULT 0,
  $columnExpenseTotal INTEGER DEFAULT 0,
  $columnExpensePerPerson INTEGER DEFAULT 0,
  $columnExpenseCount INTEGER DEFAULT 0,
  foreign key ($columnTripId) REFERENCES $tripsTable
  ($columnTripId) ON DELETE CASCADE
)
''');
    await db.execute('''
CREATE TABLE $ExpenseItemTable (
  $columnTripExpenseItemId INTEGER PRIMARY KEY,
  $columnTripId INTEGER,
  $columnTripExpenseItemAmount INTEGER,
  $columnTripExpenseItemKeyNote TEXT,
  $columnTripExpenseItemCategory TEXT,
  $columnTripExpenseItemDate TEXT,
  $columnTripExpenseItemTime TEXT,
  foreign key ($columnTripId) REFERENCES $tripsTable
  ($columnTripId) ON DELETE CASCADE
)
''');
  }

  //album function
  Future<int> insertAlbumRecord(Map<String, dynamic> row) async {
    Database db = await database;
    return await db.insert(AlbumTable, row);
  }

  //album read
  Future<List<Map<String, dynamic>>> ReadAlbumRecord(int tripId) async {
    Database db = await database;
    return await db.query(
      AlbumTable,
      where: '$columnTripId = ?',
      whereArgs: [tripId],
    );
  }

  //Users Functions
  Future<int> insertRecord(Map<String, dynamic> row) async {
    Database db = await database;
    return await db.insert(usersTable, row);
  }

  Future<List<Map<String, dynamic>>> queryDatabase() async {
    Database db = await database;
    return await db.query(usersTable);
  }

  Future<int> updateRecord(Map<String, dynamic> row) async {
    Database db = await database;
    int id = row[columnUserId];
    return await db.update(
      usersTable,
      row,
      where: '$columnUserId = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteRecord(int id) async {
    Database? db = await database;
    return await db.delete(
      usersTable,
      where: '$columnUserId = ?',
      whereArgs: [id],
    );
  }

  Future<bool> isUsernameExists(String username) async {
    Database db = await database;
    List<Map<String, dynamic>> result = await db.query(
      usersTable,
      where: '$columnUser = ?',
      whereArgs: [username],
    );
    return result.isNotEmpty;
  }

  Future<bool> validateUserCredentials(String username, String password) async {
    Database db = await database;
    List<Map<String, dynamic>> result = await db.query(
      usersTable,
      where: '$columnUser = ? AND $columnPass = ?',
      whereArgs: [username, password],
    );
    return result.isNotEmpty;
  }

  Future<Map<String, dynamic>> getUserDataByUsername(String username) async {
    Database db = await database;
    List<Map<String, dynamic>> result = await db.query(
      usersTable,
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

  //get user data by id
  Future<Map<String, dynamic>> getUserDataById(int userId) async {
    Database db = await database;
    List<Map<String, dynamic>> result = await db.query(
      usersTable,
      where: '$columnUserId = ?',
      whereArgs: [userId],
      limit: 1,
    );
    return result.isNotEmpty ? result.first : {};
  }

  Future<void> setLoggedInUser(Map<String, dynamic> userData) async {
    Database db = await database;

    // Clear the loggedIn status of existing users
    await db.update(
      usersTable,
      {columnLoggedIn: 0},
    );

    int id = userData[columnUserId];

    // Set the loggedIn status of the current user to 1
    await db.update(
      usersTable,
      {columnLoggedIn: 1},
      where: '$columnUserId = ?',
      whereArgs: [id],
    );
  }

  Future<bool> checkLoggedIn() async {
    Database db = await database;
    List<Map<String, dynamic>> result = await db.query(
      usersTable,
      where: '$columnLoggedIn = ?',
      whereArgs: [1],
    );
    return result.isNotEmpty;
  }

  Future<Map<String, dynamic>> getLoggedInUserData() async {
    Database db = await database;
    List<Map<String, dynamic>> result = await db.query(
      usersTable,
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
      int id = loggedInUserData[columnUserId];

      // Update the loggedIn status to 0
      await db.update(
        usersTable,
        {columnLoggedIn: 0},
        where: '$columnUserId = ?',
        whereArgs: [id],
      );
    }
  }

  //Trips Functions
  Future<int> insertTripRecord(Map<String, dynamic> tripData) async {
    Database db = await database;
    return await db.insert(tripsTable, tripData);
  }

  Future<void> deleteAllTrips() async {
    Database db = await database;
    await db.delete(tripsTable);
  }

  Future<bool> emptyHomeValidation(int userId) async {
    Database db = await database;
    final result = await db
        .query(tripsTable, where: '$columnUserId =?', whereArgs: [userId]);
    print('*************');
    print(result.isEmpty);
    return result.isEmpty;
  }

  //Date Range Disable
  Future<List<String>> getSelectedTripDates(int userId) async {
    Database db = await database;
    List<Map<String, dynamic>> result = await db.query(
      tripsTable,
      columns: [columnTripStartDate, columnTripEndDate],
      where: '$columnUserId = ?',
      whereArgs: [userId],
    );

    List<String> selectedDates = [];
    for (Map<String, dynamic> row in result) {
      // Add all the dates in the date range (inclusive) to the selectedDates list
      DateTime startDate = DateTime.parse(row[columnTripStartDate]);
      DateTime endDate = DateTime.parse(row[columnTripEndDate]);
      for (DateTime date = startDate;
          date.isBefore(endDate) || date.isAtSameMomentAs(endDate);
          date = date.add(Duration(days: 1))) {
        selectedDates.add(DateFormat('yyyy-MM-dd').format(date));
      }
    }

    return selectedDates;
  }

  Future<List<Map<String, dynamic>>> queryTripRecordOngoing(int userId) async {
    Database db = await database;
    final currentDate = DateTime.now();

    return await db.query(
      tripsTable,
      where:
          'userId = ? AND (tripStartDate <= ? AND tripEndDate >= ?) OR (tripStartDate = ?)',
      whereArgs: [
        userId,
        currentDate.toString(),
        currentDate.toString(),
        currentDate.toString()
      ],
      orderBy: '$columnTripStartDate ASC',
    );
  }

  Future<List<Map<String, dynamic>>> queryTripRecordUpcoming(int userId) async {
    Database db = await database;
    final currentDate = DateTime.now();
    return await db.query(tripsTable,
        where: 'userId = ? AND tripStartDate > ?',
        whereArgs: [userId, currentDate.toString()],
        orderBy: '$columnTripStartDate ASC');
  }

  Future<Map<String, dynamic>> queryUpcomingTrips(int userId) async {
    Database db = await database;
    final currentDate = DateTime.now();

    List<Map<String, dynamic>> tripRecords = await db.query(tripsTable,
        where: 'userId = ? AND tripStartDate > ?',
        whereArgs: [userId, currentDate.toString()],
        orderBy: '$columnTripStartDate ASC');

    int upcomingTripCount = tripRecords.length;
    print('*********++++++++++++');
    print(upcomingTripCount);

    return {
      'tripRecords': tripRecords,
      'upcomingTripCount': upcomingTripCount,
    };
  }

  Future<List<Map<String, dynamic>>> queryTripRecordRecent(int userId) async {
    Database db = await database;
    final currentDate = DateTime.now();
    return await db.query(tripsTable,
        where: 'userId = ? AND tripStartDate < ? AND tripEndDate < ?',
        whereArgs: [userId, currentDate.toString(), currentDate.toString()],
        orderBy: '$columnTripStartDate ASC');
  }

  Future<List<Map<String, Object?>>> getTripDetails(int tripId) async {
    Database db = await database;
    return await db.query(
      tripsTable,
      where: 'tripId = ?',
      whereArgs: [tripId],
    );
  }

  //GET USER DETAILS :
  Future<List<Map<String, Object?>>> getUserDetails(int userId) async {
    Database db = await database;
    return await db.query(
      usersTable,
      where: 'userId = ?',
      whereArgs: [userId],
    );
  }

  Future<int> updateTripRecord(
      int? tripid, Map<String, dynamic> tripData) async {
    //   if (tripData[columnTripId] == null) {
    //   throw ArgumentError("Trip data must contain a valid 'columnTripId' key.");
    // }
    print(tripid);
    print('****************');
    print(tripData);
    Database db = await database;

    return await db.update(
      tripsTable,
      tripData,
      where: '$columnTripId = ?',
      whereArgs: [tripid],
    );
  }

  //update profile
  Future<int> updateProfileRecord(
      int? userId, Map<String, dynamic> profileData) async {
    Database db = await database;

    Map<String, dynamic> updatedData = {
      'userName': profileData['userName'] ?? '',
      'userEmail': profileData['userEmail'] ?? '',
      // Add other fields if needed, but make sure to include their existing values
    };

    return await db.update(
      usersTable,
      updatedData,
      where: '$columnUserId = ?',
      whereArgs: [userId],
    );
  }

  Future<int> deleteTripRecord(int? id) async {
    Database? db = await database;
    return await db.delete(
      tripsTable,
      where: '$columnTripId = ?',
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
    int id = row[columnCheckPointsId];
    return await db.update(
      checkPointsTable,
      row,
      where: '$columnCheckPointsId = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteCheckpointRecord(int id) async {
    Database? db = await database;
    return await db.delete(
      checkPointsTable,
      where: '$columnCheckPointsId = ?',
      whereArgs: [id],
    );
  }

  //Activities Functions
  Future<int> insertActivityRecord(Map<String, dynamic> row) async {
    Database db = await database;
    return await db.insert(ActivitiesTable, row);
  }

  Future<List<Map<String, dynamic>>> getTripActivities(int tripId) async {
    final db = await database;
    List<Map<String, dynamic>> result = await db.query(
      ActivitiesTable,
      where: '$columnTripId = ?',
      whereArgs: [tripId],
    );
    print(result);
    return result;
  }

  Future<List<Map<String, dynamic>>> queryActivityRecord() async {
    Database db = await database;
    return await db.query(ActivitiesTable);
  }

  Future<int> updateActivityRecord(Map<String, dynamic> row) async {
    Database db = await database;
    int id = row[columnActivitiesId];
    return await db.update(
      ActivitiesTable,
      row,
      where: '$columnActivitiesId = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteActivityRecord(int id) async {
    Database? db = await database;
    return await db.delete(
      ActivitiesTable,
      where: '$columnActivitiesId = ?',
      whereArgs: [id],
    );
  }

  updateTripNotes(int tripId, String updatedNotes) async {
    Database? db = await database;
    return await db.update(
      tripsTable,
      {'tripNotes': updatedNotes},
      where: '$tripId = ?',
      whereArgs: [tripId],
    );
  }

  // Future<List<Map<String, dynamic>>> getTripActivities(int tripId) async {
  //   final db = await database;
  //   List<Map<String, dynamic>> result =  await db.query(
  //     ActivitiesTable,
  //     where: '$columnTripId = ?',
  //     whereArgs: [tripId],
  //   );
  //   print(result);
  //   return result;
  // }
  Future<List<Map<String, dynamic>>> fetchExpenseInfo(int tripId) async {
    final db = await database;
    List<Map<String, dynamic>> fetch = await db.query(
      ExpenseTable,
      where: '$columnTripId = ?',
      whereArgs: [tripId],
    );
    return fetch;
  }
  //  Future<int> insertTripRecord(Map<String, dynamic> tripData) async {
  //   Database db = await database;
  //   return await db.insert(tripsTable, tripData);
  // }

  Future<int> insertExpenseOverview(
      Map<String, dynamic> expenseOverview) async {
    Database db = await database;
    return await db.insert(ExpenseTable, expenseOverview);
  }

  // Future<List<Map<String, dynamic>>> readAllTrips() async {
  //   Database db = await database;
  //   List<Map<String, dynamic>> maps = await db.query("trips");
  //   return maps;
  // }

  Future<List<Map<String, dynamic>>> readAllTrips() async {
    Database db = await database;
    return await db.query(tripsTable);
  }
}
