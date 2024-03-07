class TimeEntry {
  int? _id;
  DateTime startDate;
  DateTime endDate;
  double hours;
  double wages;
  String note;

  int? get id => _id; // getter for _id

  TimeEntry(
      {required this.startDate,
      required this.endDate,
      required this.hours,
      required this.wages,
      required this.note});

  TimeEntry.fromUser(
      {required this.startDate,
      required this.endDate,
      required this.note,
      required double hourlyRate})
      : hours = endDate.difference(startDate).inHours.toDouble(),
        wages = endDate.difference(startDate).inHours.toDouble() * hourlyRate;

  TimeEntry.map(dynamic obj)
      : _id = obj['id'],
        startDate = DateTime.parse(obj['startDate']),
        endDate = DateTime.parse(obj['endDate']),
        hours = obj['hours'],
        wages = obj['wages'],
        note = obj['note'];

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    if (_id != null) {
      map['id'] = _id;
    }
    map['startDate'] = startDate.toString();
    map['endDate'] = endDate.toString();
    map['hours'] = hours;
    map['wages'] = wages;
    map['note'] = note;

    return map;
  }

  TimeEntry.fromMap(Map<String, dynamic> map)
      : _id = map['id'],
        startDate = DateTime.parse(map['startDate']),
        endDate = DateTime.parse(map['endDate']),
        hours = map['hours'],
        wages = map['wages'],
        note = map['note'];

  void setEntryId(int id) {
    _id = id;
  }
}
