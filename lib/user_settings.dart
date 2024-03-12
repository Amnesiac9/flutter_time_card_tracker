import 'package:flutter/foundation.dart';
import 'package:time_card_tracker/database.dart';

class UserSettings extends ChangeNotifier {
  String theme = 'default';
  String language = 'language';
  int isDark = 1;
  String currency = 'USD';
  double hourlyRate = 20.00;
  double taxRate = 10; // 10%
  String hoursFormat = '12 Hour';
  String dateFormat = 'yyyy-MM-dd hh:mma';
  int reminders = 1;
  String reminderTime = '17:00';
  String lastBackup = '';
  String dailyBackupTime = '00:00';
  String filter = 'PayPeriod';
  final DatabaseHelper database;

  UserSettings({required this.database});

  // Function to get settings from the database
  Future<void> getSettingsFromDatabase() async {
    Map<String, dynamic> settings = await database.getSettings();

    // Set the values retrieved from the database to the class fields
    if (settings.isNotEmpty) {
      print('settings not empty.');
      print('isDark: ${settings['isDark']}');
      //print('settings: $settings');

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

    print(settings);
  }

  // Function to get the currency symbol
  String getCurrencySymbol() {
    switch (currency) {
      case 'EUR':
        return '€';
      case 'GBP':
        return '£';
      default:
        return '\$';
    }
  }

  void toggleDarkMode() {
    isDark = isDark == 0 ? 1 : 0;
    notifyListeners();
    saveSettingsToDatabase();
  }

  void setTheme(String newTheme) {
    theme = newTheme;
    notifyListeners();
    saveSettingsToDatabase();
  }

  void setLanguage(String newLanguage) {
    language = newLanguage;
    notifyListeners();
    saveSettingsToDatabase();
  }

  void setCurrency(String newCurrency) {
    currency = newCurrency;
    notifyListeners();
    saveSettingsToDatabase();
  }

  void setHourlyRate(double newHourlyRate) {
    hourlyRate = newHourlyRate;
    notifyListeners();
    saveSettingsToDatabase();
  }

  void setTaxRate(double newTaxRate) {
    taxRate = newTaxRate;
    notifyListeners();
    saveSettingsToDatabase();
  }

  void setHoursFormat(String newHoursFormat) {
    hoursFormat = newHoursFormat;
    notifyListeners();
    saveSettingsToDatabase();
  }

  void setDateFormat(String newDateFormat) {
    dateFormat = newDateFormat;
    notifyListeners();
    saveSettingsToDatabase();
  }

  void setReminders(int newReminders) {
    reminders = newReminders;
    notifyListeners();
    saveSettingsToDatabase();
  }

  void setReminderTime(String newReminderTime) {
    reminderTime = newReminderTime;
    notifyListeners();
    saveSettingsToDatabase();
  }

  void setLastBackup(String newLastBackup) {
    lastBackup = newLastBackup;
    notifyListeners();
    saveSettingsToDatabase();
  }

  void setDailyBackupTime(String newDailyBackupTime) {
    dailyBackupTime = newDailyBackupTime;
    notifyListeners();
    saveSettingsToDatabase();
  }

  void setFilter(String newFilter) {
    filter = newFilter;
    notifyListeners();
    saveSettingsToDatabase();
  }

  void saveSettingsToDatabase() {
    database.saveSettings({
      'theme': theme,
      'language': language,
      'isDark': isDark,
      'currency': currency,
      'hourlyRate': hourlyRate,
      'taxRate': taxRate,
      'hoursFormat': hoursFormat,
      'dateFormat': dateFormat,
      'reminders': reminders,
      'reminderTime': reminderTime,
      'lastBackup': lastBackup,
      'dailyBackupTime': dailyBackupTime,
      'filter': filter,
    });
    print('settings saved to database.');
    print('isDark: $isDark');
  }
}
