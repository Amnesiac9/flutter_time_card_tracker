import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:time_card_tracker/database.dart';
import 'package:time_card_tracker/settings.dart';
import 'package:time_card_tracker/settings_page.dart';
import 'package:time_card_tracker/time_entry.dart';
import 'package:time_card_tracker/time_entry_widget.dart';
import 'package:time_card_tracker/time_picker_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    DatabaseHelper dbHelper = DatabaseHelper();
    //dbHelper.deleteDatabaseFile(); // Delete the database file
    UserSettings.getSettingsFromDatabase(dbHelper);

    // ignore: prefer_const_constructors
    Color seedColor = Color.fromARGB(255, 29, 107, 95);
    Brightness brightness = Brightness.dark;
    Color background = Colors.black;

    if (UserSettings.theme != 'default') {
      seedColor = Color(int.parse(UserSettings.theme));
    }

    // Check if the user has selected a light theme
    if (UserSettings.isDark == 0) {
      brightness = Brightness.light;
      background = Colors.white;
    }

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

    return MaterialApp(
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

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DatabaseHelper dbHelper = DatabaseHelper();
  int _counter = 0;
  var _entries = <Widget>[];

  final dateFormat = DateFormat('yyyy-MM-dd hh:mma');

  void _getEntriesAsync() async {
    List<TimeEntry> dbEntries = await dbHelper.getEntries();
    setState(() {
      _entries = dbEntries
          .map((entry) => GestureDetector(
              onLongPress: () {
                _showPopupMenu(entry.id!);
              },
              child: Dismissible(
                  key: Key('${entry.id}'),
                  onDismissed: (direction) {
                    _deleteEntry(entry.id!);
                  },
                  child: EntryWidget(
                    startDate: entry.startDate,
                    endDate: entry.endDate,
                    hours: entry.hours,
                    wages: entry.wages,
                    note: entry.note,
                  ))))
          .toList();
      _counter = _entries.length;
    });
  }

  Widget _getEntries() {
    return _entries.isEmpty
        ? const Text('No entries yet')
        : ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: _entries.length,
            itemBuilder: (context, index) => _entries[index],
          );
  }

  void _createNewEntry() async {
    CustomTimePickerDialog.show(
      context: context,
      title: 'New Timecard Entry',
      startDate: DateTime.now(),
      endDate: DateTime.now().add(const Duration(hours: 8)),
      entry: TimeEntry.fromUser(
        startDate: DateTime.now(),
        endDate: DateTime.now().add(const Duration(hours: 8)),
        note: '',
        hourlyRate: UserSettings.hourlyRate,
      ),
      onSave: (entry) {
        appendEntry(entry);
      },
      dateFormat: dateFormat,
    );
  }

  void appendEntry(entry) {
    dbHelper.saveEntry(entry);
    _getEntriesAsync();
    setState(() {
      _counter++;
    });
  }

  void _deleteEntry(int id) {
    dbHelper.deleteEntry(id); // Delete from database
    setState(() {
      _counter--;
    });
    _getEntriesAsync();
  }

  void _editEntry(int id) {
    // Navigate to edit page
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => EditEntryPage(
    //       entryId: id,
    //     ),
    //   ),
    // );
  }

  void _showPopupMenu(int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Context Menu'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text('Delete'),
                onTap: () {
                  _deleteEntry(id);
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
              // Add more ListTiles here for other menu items
            ],
          ),
        );
      },
    );
  }

  // Run once when the widget is first created
  @override
  void initState() {
    super.initState();
    _getEntriesAsync();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.filter_alt),
            onPressed: () => print('Filter'),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              //Navigate to settings page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(
              top: 5,
              bottom: 0,
            ),
            child: Text(
              "Filter: Pay Period",
              style: TextStyle(fontSize: 10),
            ),
          ),
          Expanded(
            child: Center(
              child: _getEntries(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createNewEntry,
        tooltip: 'Add Entry',
        child: const Icon(Icons.alarm_add_rounded),
      ),
    );
  }
}
