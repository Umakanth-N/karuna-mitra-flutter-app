


class Reminder {
  final String name;
  final String dosage;
  final String description;
  final DateTime dateTime;

  Reminder({
    required this.name,
    required this.dosage,
    required this.description,
    required this.dateTime,
  });
}




// class ReminderScreen extends StatefulWidget {
//   @override
//   _ReminderScreenState createState() => _ReminderScreenState();
// }

// class _ReminderScreenState extends State<ReminderScreen> {
//   late List<Reminder> _reminders;

//   @override
//   void initState() {
//     super.initState();
//     _reminders = [];
//     DatabaseReference reference =
//         FirebaseDatabase.instance.reference().child('reminders');
//     reference.onChildAdded.listen(_onEntryAdded);
//     reference.onChildChanged.listen(_onEntryChanged);
//   }

//   void _onEntryAdded(Event event) {
//     setState(() {
//       _reminders.add(Reminder(
//         name: event.snapshot.value['name'],
//         dosage: event.snapshot.value['dosage'],
//         description: event.snapshot.value['description'],
//         dateTime: DateTime.parse(event.snapshot.value['dateTime']),
//       ));
//     });
//   }

//   void _onEntryChanged(Event event) {
//     var oldEntry = _reminders.singleWhere(
//         (entry) => entry.dateTime.toString() == event.snapshot.key);
//     setState(() {
//       _reminders[_reminders.indexOf(oldEntry)] = Reminder(
//         name: event.snapshot.value['name'],
//         dosage: event.snapshot.value['dosage'],
//         description: event.snapshot.value['description'],
//         dateTime: DateTime.parse(event.snapshot.value['dateTime']),
//       );
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Reminders'),
//       ),
//       body: ListView.builder(
//         itemCount: _reminders.length,
//         itemBuilder: (context, index) {
//           return ListTile(
//             title: Text(_reminders[index].name),
//             subtitle: Text(
//                 '${_reminders[index].dosage}\n${_reminders[index].description}\n${_reminders[index].dateTime}'),
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           _showDialog(context);
//         },
//         child: Icon(Icons.add),
//       ),
//     );
//   }
// }
