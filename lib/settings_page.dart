import 'package:flutter/material.dart';
import 'package:time_card_tracker/custom_widget_settings_tile.dart';
import 'package:time_card_tracker/settings.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Center(
        child: ListView(
          children: <Widget>[
            ExpansionTile(
              title: const Text('Theme'),
              children: <Widget>[
                CustomSettingsTile(
                  title: const Text('Light'),
                  settingType: SettingType.toggle,
                  toggleValue: UserSettings.isDark == 0 ? false : true,
                ),
                ListTile(
                  title: const Text('Dark'),
                  onTap: () {
                    // Navigate to dark theme settings
                  },
                ),
              ],
            ),
            ListTile(
              title: const Text('Language'),
              onTap: () {
                // Navigate to language settings
              },
            ),
            ListTile(
              title: const Text('Currency'),
              onTap: () {
                // Navigate to currency settingss
              },
            ),
            ListTile(
              title: const Text('Hourly Rate'),
              onTap: () {
                // Navigate to hourly rate settings
              },
            ),
            ListTile(
              title: const Text('Tax Rate'),
              onTap: () {
                // Navigate to tax rate settings
              },
            ),
            ListTile(
              title: const Text('Hours Format'),
              onTap: () {
                // Navigate to hours format settings
              },
            ),
            ListTile(
              title: const Text('Date Format'),
              onTap: () {
                // Navigate to date format settings
              },
            ),
            ListTile(
              title: const Text('Reminders'),
              onTap: () {
                // Navigate to reminders settings
              },
            ),
            ListTile(
              title: const Text('Backup'),
              onTap: () {
                // Navigate to backup settings
              },
            ),
            ListTile(
              title: const Text('Filter'),
              onTap: () {
                // Navigate to filter settings
              },
            ),
          ],
        ),
      ),
    );
  }
}
