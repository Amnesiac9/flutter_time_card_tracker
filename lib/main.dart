import 'package:flutter/material.dart';
import 'package:time_card_tracker/database.dart';
import 'package:time_card_tracker/time_entry.dart';
import 'package:time_card_tracker/time_entry_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    const myTheme = ColorScheme.dark(primaryContainer: Colors.red);

    var myTheme2 = ColorScheme.fromSeed(
      seedColor: const Color.fromARGB(255, 29, 107, 95),
      brightness: Brightness.dark,
      background: Colors.black,
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
        colorScheme: myTheme2,
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
  int _counter = 0;
  var _entries = <Widget>[];
  DatabaseHelper dbHelper = DatabaseHelper();

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

  void _appendEntry() {
    TimeEntry entry = TimeEntry.fromUser(
      startDate: DateTime.now(),
      endDate: DateTime.now().add(const Duration(hours: 8)),
      note: 'Entry ${_counter + 1}',
      hourlyRate: 15.0, // Need to get this from user settings
    );

    dbHelper.saveEntry(entry);
    _getEntriesAsync();
    setState(() {
      _counter++;
      //_entries = List.from(_entries);
    });
  }

  void _deleteEntry(int id) {
    dbHelper.deleteEntry(id); // Delete from database
    setState(() {
      // _entries.removeWhere((element) =>
      //     element.key ==
      //     Key(id.toString())); // Remove the entry at the given index
      _counter--;
    });
    _getEntriesAsync();
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
      ),
      body: Center(
        child: _getEntries(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _appendEntry,
        tooltip: 'Add Entry',
        child: const Icon(Icons.alarm_add_rounded),
      ),
    );
  }
}
