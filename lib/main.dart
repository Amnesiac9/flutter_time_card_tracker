import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:time_card_tracker/database.dart';
import 'package:time_card_tracker/home_page.dart';
import 'package:provider/provider.dart';
import 'package:time_card_tracker/user_settings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //final database = DatabaseHelper();
  final userSettings = UserSettings();
  await userSettings.getSettingsFromDatabase();

  runApp(
    ChangeNotifierProvider<UserSettings>.value(
      value: userSettings,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //DatabaseHelper dbHelper = DatabaseHelper();
    //UserSettings2 userSettings = UserSettings2();
    //dbHelper.deleteDatabaseFile(); // Delete the database file
    //userSettings.getSettingsFromDatabase();
    UserSettings userSettings = Provider.of<UserSettings>(context);

    // ignore: prefer_const_constructors
    Color seedColor = Color.fromARGB(255, 29, 107, 95);
    Brightness brightness = Brightness.dark;
    Color background = Colors.black;

    if (userSettings.theme != 'default') {
      seedColor = Color(int.parse(userSettings.theme));
    }

    // Check if the user has selected a light theme
    if (userSettings.isDark == 0) {
      brightness = Brightness.light;
      background = Colors.white;
    }

    print('seedColor: $seedColor');
    print('brightness: $brightness');
    print('background: $background');

// Construct the theme
    var myTheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: brightness,
      background: background,
      // tertiary: Colors.black,
      // tertiaryContainer: Colors.black,
      // onTertiaryContainer: Colors.black,
      // secondaryContainer: Colors.black,
      // onSecondaryContainer: Colors.black,
      // surface: Colors.black,
      // surfaceTint: Colors.black,
      //primaryContainer: Colors.black, // + Button

      //primary: Colors.black,
      //secondary: Colors.black
    );

    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: myTheme,
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Time Tracker'),
    );
  }
}
