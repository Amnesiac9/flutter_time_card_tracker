import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' as io;
import 'dart:async';
import 'package:path/path.dart' as p;

import 'package:time_card_tracker/time_entry.dart';

// Create a database helper class that will handle all the database operations
class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;
  static Database? _db;

  // Create a getter for the database, this is run when the database is first accessed and will create the database if it doesn't exist
  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await setDB();
    return _db!;
  }

  // Ensure only one instance of the database is created (singleton pattern)
  DatabaseHelper.internal();

  // initialize the database if it doesn't exist, and create the tables
  setDB() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = p.join(documentDirectory.path, 'main.db');
    var ourDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return ourDb;
  }

  // Create the tables, only run if the database file doesn't exist. Is called in setDB.
  void _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE Entry(id INTEGER PRIMARY KEY, startDate TEXT, endDate TEXT, hours REAL, wages REAL, note TEXT)');
    await db.execute(
        'CREATE TABLE Settings(id INTEGER PRIMARY KEY, theme TEXT, language TEXT, isDark INTEGER, currency TEXT, hourlyRate REAL, taxRate REAL, hoursFormat TEXT, dateFormat TEXT, reminders INTEGER, reminderTime TEXT, lastBackup TEXT, dailyBackupTime TEXT, filter TEXT)');
    print('Database was created!');
  }

  // Database helper method to save a time entry into the Entry database table.
  // The method returns the id of the inserted entry.
  // The method takes a TimeEntry and converts it to a map to insert into the database.
  // The TimeEntry class's fields must match the database table's fields names for this to work.
  Future<int> saveEntry(TimeEntry entry) async {
    var dbClient = await db;
    int res = await dbClient.insert("Entry", entry.toMap());
    return res;
  }

  // Database helper method to get all the time entries from the Entry database table.
  // returns a list of TimeEntry objects from the database.
  Future<List<TimeEntry>> getEntries() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM Entry');
    List<TimeEntry> entries = [];
    // Loop through the list of maps and convert each map (Key value pair) to a TimeEntry object
    for (int i = 0; i < list.length; i++) {
      var entry = TimeEntry(
        startDate: DateTime.parse(list[i]["startDate"]),
        endDate: DateTime.parse(list[i]["endDate"]),
        hours: list[i]["hours"],
        wages: list[i]["wages"],
        note: list[i]["note"],
      );
      entry.setEntryId(list[i]["id"]);
      entries.add(entry);
    }
    return entries;
  }

  getEntry(int id) async {
    var dbClient = await db;
    var res = await dbClient.rawQuery('SELECT * FROM Entry WHERE id = ?', [id]);
    if (res.isEmpty) return null;
    return TimeEntry.fromMap(res.first);
  }

  Future<int> deleteEntry(int id) async {
    var dbClient = await db;
    int res = await dbClient.rawDelete('DELETE FROM Entry WHERE id = ?', [id]);
    return res;
  }

  Future<int> updateEntry(TimeEntry entry) async {
    var dbClient = await db;
    int res = await dbClient.update("Entry", entry.toMap(),
        where: "id = ?", whereArgs: <int>[entry.id!]);
    return res;
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }

  Future<int> saveSettings(Map<String, dynamic> settings) async {
    var dbClient = await db;
    int res = await dbClient.update(
      "Settings",
      settings,
      where: "id = ?",
      whereArgs: [1], // Assuming the ID of your settings row is 1
    );
    if (res == 0) {
      // If no row was updated, insert a new row
      res = await dbClient.insert("Settings", settings);
    }
    print(res);
    return res;
  }

  Future<Map<String, dynamic>> getSettings() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM Settings');

    if (list.isNotEmpty) {
      return list.first.cast<String, dynamic>();
    } else {
      return {};
    }
  }

  //Only used for testing and resetting the db
  Future<void> deleteDatabaseFile() async {
    try {
      // Get the directory where the database file is located
      Directory documentsDirectory = await getApplicationDocumentsDirectory();
      String path = documentsDirectory.path;

      // Specify the name of your database file
      String databaseFileName = 'main.db';

      // Construct the full path to the database file
      String databaseFilePath = '$path/$databaseFileName';

      // Check if the database file exists
      bool exists = await File(databaseFilePath).exists();

      if (exists) {
        // Delete the database file
        await File(databaseFilePath).delete();
        print('Database file deleted successfully.');
      } else {
        print('Database file does not exist.');
      }
    } catch (e) {
      print('Error deleting database file: $e');
    }
  }
}
