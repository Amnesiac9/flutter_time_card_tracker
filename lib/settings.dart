//     'CREATE TABLE Settings(id INTEGER PRIMARY KEY, theme TEXT, language TEXT, isDark INT, currency TEXT, hourlyRate REAL, taxRate REAL, hoursFormat TEXT, dateFormat TEXT, reminders INTEGER, reminderTime TEXT, lastBackup TEXT, dailyBackupTime TEXT, filter TEXT)');

import 'package:time_card_tracker/database.dart';

class UserSettings {
  static String theme = 'default';
  static String language = 'language';
  static int isDark = 1;
  static String currency = 'USD';
  static double hourlyRate = 20.00;
  static double taxRate = 10; // 10%
  static String hoursFormat = '12 Hour';
  static String dateFormat = 'yyyy-MM-dd hh:mma';
  static int reminders = 1;
  static String reminderTime = '17:00';
  static String lastBackup = '';
  static String dailyBackupTime = '00:00';
  static String filter = 'PayPeroid';

  // Function to get settings from the database
  static Future<void> getSettingsFromDatabase(DatabaseHelper database) async {
    // Call your function to retrieve settings from the database
    // For example:
    Map<String, dynamic> settings = await database.getSettings();

    // Set the values retrieved from the database to the class fields
    if (settings.isNotEmpty) {
      theme = settings['theme'];
      language = settings['language'];
      isDark = settings['isDark'];
      currency = settings['currency'];
      hourlyRate = settings['hourlyRate'];
      taxRate = settings['taxRate'];
      hoursFormat = settings['hoursFormat'];
      dateFormat = settings['dateFormat'];
      reminders = settings['reminders'];
      reminderTime = settings['reminderTime'];
      lastBackup = settings['lastBackup'];
      dailyBackupTime = settings['dailyBackupTime'];
      filter = settings['filter'];
    }
  }
}
