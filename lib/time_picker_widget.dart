import 'package:flutter/material.dart';
import 'package:time_card_tracker/time_entry.dart';
import 'package:intl/intl.dart';

class CustomTimePickerDialog {
  static Future<void> show({
    required BuildContext context,
    required String title,
    required DateTime startDate,
    required DateTime endDate,
    required TimeEntry entry,
    required Function(TimeEntry) onSave,
    required DateFormat dateFormat,
  }) async {
    // DateTime startDate0 = startDate;
    // DateTime endDate0 = endDate;
    // String note0 = note;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text(title),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    onChanged: (value) {
                      entry.note = value;
                    },
                    decoration: const InputDecoration(
                      hintText: 'Note',
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: startDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (date != null) {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(startDate),
                        );
                        if (time != null) {
                          startDate = DateTime(
                            date.year,
                            date.month,
                            date.day,
                            time.hour,
                            time.minute,
                          );
                          setState(() {}); // This will rebuild the AlertDialog
                        }
                      }
                    },
                    child: Text('Start: ${dateFormat.format(startDate)}'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: endDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (date != null) {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(endDate),
                        );
                        if (time != null) {
                          endDate = DateTime(
                            date.year,
                            date.month,
                            date.day,
                            time.hour,
                            time.minute,
                          );
                          setState(() {}); // This will rebuild the AlertDialog
                        }
                      }
                    },
                    child: Text('End: ${dateFormat.format(endDate)}'),
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    entry.startDate = startDate;
                    entry.endDate = endDate;
                    //entry.note = note;
                    onSave(entry);
                    Navigator.of(context).pop();
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
