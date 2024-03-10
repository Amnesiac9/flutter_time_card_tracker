import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:time_card_tracker/database.dart';
import 'package:time_card_tracker/settings.dart';
import 'package:time_card_tracker/settings_page.dart';
import 'package:time_card_tracker/time_entry.dart';
import 'package:time_card_tracker/time_entry_widget.dart';
import 'package:time_card_tracker/time_picker_widget.dart';

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

  //final dateFormat = DateFormat('yyyy-MM-dd hh:mma');

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
      dateFormat: DateFormat(UserSettings.dateFormat),
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
