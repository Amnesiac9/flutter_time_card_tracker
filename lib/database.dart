import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' as io;
import 'dart:async';
import 'package:path/path.dart' as p;

import 'package:time_card_tracker/time_entry.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;
  static Database? _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await setDB();
    return _db!;
  }

  DatabaseHelper.internal();

  setDB() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = p.join(documentDirectory.path, 'main.db');
    var ourDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return ourDb;
  }

  void _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE Entry(id INTEGER PRIMARY KEY, startDate TEXT, endDate TEXT, hours REAL, wages REAL, note TEXT)');
    await db.execute(
        'CREATE TABLE Settings(id INTEGER PRIMARY KEY, hourlyRate REAL, currency TEXT, taxRate REAL, hoursFormat TEXT, dateFormat TEXT, theme TEXT, language TEXT, reminders INTEGER, reminderTime TEXT, lastBackup TEXT, dailyBackupTime TEXT, filter TEXT)');
  }

  Future<int> saveEntry(TimeEntry entry) async {
    var dbClient = await db;
    int res = await dbClient.insert("Entry", entry.toMap());
    return res;
  }

  Future<List<TimeEntry>> getEntries() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM Entry');
    List<TimeEntry> entries = [];
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
    int res = await dbClient.insert("Settings", settings);
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
}
