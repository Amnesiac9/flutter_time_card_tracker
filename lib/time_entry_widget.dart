import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:time_card_tracker/settings.dart';

class EntryWidget extends StatelessWidget {
  final DateTime startDate;
  final DateTime endDate;
  final double hours;
  final double wages;
  final String note;

  const EntryWidget({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.hours,
    required this.wages,
    required this.note,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat(UserSettings.dateFormat);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            RichText(
              text: TextSpan(
                text: 'Start: ',
                style: DefaultTextStyle.of(context)
                    .style
                    .copyWith(fontWeight: FontWeight.bold),
                children: <TextSpan>[
                  TextSpan(
                      text: dateFormat.format(startDate),
                      style: const TextStyle(fontWeight: FontWeight.normal)),
                ],
              ),
            ),
            RichText(
              text: TextSpan(
                text: 'End: ',
                style: DefaultTextStyle.of(context)
                    .style
                    .copyWith(fontWeight: FontWeight.bold),
                children: <TextSpan>[
                  TextSpan(
                      text: dateFormat.format(endDate),
                      style: const TextStyle(fontWeight: FontWeight.normal)),
                ],
              ),
            ),
            RichText(
              text: TextSpan(
                text: 'Hours: ',
                style: DefaultTextStyle.of(context)
                    .style
                    .copyWith(fontWeight: FontWeight.bold),
                children: <TextSpan>[
                  TextSpan(
                      text: hours.toStringAsFixed(2),
                      style: const TextStyle(fontWeight: FontWeight.normal)),
                ],
              ),
            ),
            RichText(
              text: TextSpan(
                text: 'Wages: ',
                style: DefaultTextStyle.of(context)
                    .style
                    .copyWith(fontWeight: FontWeight.bold),
                children: <TextSpan>[
                  TextSpan(
                      text:
                          '${UserSettings.getCurrencySymbol()}${wages.toStringAsFixed(2)}',
                      style: const TextStyle(fontWeight: FontWeight.normal)),
                ],
              ),
            ),
            RichText(
              text: TextSpan(
                text: 'Note: ',
                style: DefaultTextStyle.of(context)
                    .style
                    .copyWith(fontWeight: FontWeight.bold),
                children: <TextSpan>[
                  TextSpan(
                      text: note,
                      style: const TextStyle(fontWeight: FontWeight.normal)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
