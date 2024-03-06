import 'package:flutter/material.dart';

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

  void _appendEntry() {
    setState(() {
      _counter++;
      _entries = List.from(_entries)
        ..add(
          GestureDetector(
            onLongPress: () {
              _showPopupMenu(_counter - 1);
            },
            child: Dismissible(
              key: Key('Entry $_counter'),
              onDismissed: (direction) {
                setState(() {
                  _entries.removeWhere(
                      (element) => element.key == Key('Entry $_counter'));
                });
              },
              child: Card(
                child: SizedBox(
                  height: 60,
                  child: Center(child: Text('Entry $_counter')),
                ),
              ),
            ),
          ),
        );
    });
  }

  void _deleteEntry(int index) {
    setState(() {
      _entries.removeAt(index); // Remove the entry at the given index
    });
  }

  void _showPopupMenu(int index) {
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
                  _deleteEntry(index);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: _entries.isEmpty
            ? const Text('No entries yet')
            : ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: _entries.length,
                itemBuilder: (context, index) => GestureDetector(
                  onLongPress: () {
                    _showPopupMenu(index);
                  },
                  child: Card(
                    child: SizedBox(
                      height: 60,
                      child: Center(child: Text('Entry ${index + 1}')),
                    ),
                  ),
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _appendEntry,
        tooltip: 'Add Entry',
        child: const Icon(Icons.add),
      ),
    );
  }
}
