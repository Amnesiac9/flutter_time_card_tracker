import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_card_tracker/custom_widget_settings_tile.dart';
import 'package:time_card_tracker/user_settings.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserSettings>(builder: (context, userSettings, child) {
      print('userSettings ${userSettings.isDark}');
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
                    title: const Text('Dark Mode'),
                    settingType: SettingType.toggle,
                    toggleValue: userSettings.isDark == 0 ? false : true,
                    onToggleChanged: (value) => userSettings.toggleDarkMode(),
                  ),
                  // ListTile(
                  //   title: const Text('Dark'),
                  //   onTap: () {
                  //     // Navigate to dark theme settings
                  //   },
                  //),
                ],
              ),
              ListTile(
                title: const Text('Language'),
                onTap: () {
                  // Navigate to language settings
                },
              ),
            ],
          ),
        ),
      );
    });
  }
}
