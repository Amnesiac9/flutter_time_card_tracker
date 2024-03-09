//     'CREATE TABLE Settings(id INTEGER PRIMARY KEY, theme TEXT, language TEXT, isDark INT, currency TEXT, hourlyRate REAL, taxRate REAL, hoursFormat TEXT, dateFormat TEXT, reminders INTEGER, reminderTime TEXT, lastBackup TEXT, dailyBackupTime TEXT, filter TEXT)');

import 'dart:ffi';

class UserSettings {
  static const String theme = 'theme';
  static const String language = 'language';
  static const int isDark = 1;
  static const String currency = 'USD';
  static const double hourlyRate = 20.00;
  static const double taxRate = 10; // 10%
  static const String hoursFormat = '12 Hour';
  static const String dateFormat = 'yyyy-MM-dd hh:mma';
  static const int reminders = 1;
  static const String reminderTime = '17:00';
  static const String lastBackup = '';
  static const String dailyBackupTime = '00:00';
  static const String filter = 'PayPeroid';
}
