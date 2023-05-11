import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:karunamitra/widgets/widgets.dart';
import 'package:intl/intl.dart';


class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final AndroidInitializationSettings _androidInitializationSettings =
      const AndroidInitializationSettings("logo");

  void initialNotification() async {
    InitializationSettings initializationSettings =
        InitializationSettings(android: _androidInitializationSettings);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // loc noti

  

  void sendNotification(String title, String body) async {
    AndroidNotificationDetails androidNotificationDetails =
        const AndroidNotificationDetails("channelId", "channelName",
        
            importance: Importance.max, priority: Priority.high,
            sound:RawResourceAndroidNotificationSound('noti'),
            );
    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    await flutterLocalNotificationsPlugin.show(
        0, title, body, notificationDetails);
  }




  /// Schudual

  void schuNotification(String title, String body) async {
    AndroidNotificationDetails androidNotificationDetails =
        const AndroidNotificationDetails("channelId", "channelName",
            importance: Importance.max, priority: Priority.high,
            // playSound: false, 
            sound:RawResourceAndroidNotificationSound('noti')
            
            );
    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    await flutterLocalNotificationsPlugin.periodicallyShow(
        0, title, body, RepeatInterval.everyMinute, notificationDetails);
  }
}

class Remainder extends StatefulWidget {
  const Remainder({super.key});

  @override
  State<Remainder> createState() => _RemainderState();
}

class _RemainderState extends State<Remainder> {
  NotificationService notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    notificationService.initialNotification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Button(
              text: 'Notification',
              icons: Icons.notification_add,
              onPress: () {
                           Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ReminderCard()));
              }),
          Button(
              text: 'SchNotification',
              icons: Icons.notification_add,
              onPress: () {
                notificationService.schuNotification(
                    'schudul Local Noti', "Some Notification text");
              }),
        ],
      ),
    );
  }
}






  class ReminderCard extends StatefulWidget {
  const ReminderCard({Key? key}) : super(key: key);

  @override
  _ReminderCardState createState() => _ReminderCardState();
}

class _ReminderCardState extends State<ReminderCard> {

  late String _name;
  late String _dosage;
  late String _description;
  late DateTime _dateTime;

  final _formKey = GlobalKey<FormState>();
  NotificationService notificationService = NotificationService();
  @override
  void initState() {
    super.initState();
    _dateTime = DateTime.now();

      notificationService.initialNotification();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _name = value;
                  });
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Dosage',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a dosage';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _dosage = value;
                  });
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Description',
                ),
                onChanged: (value) {
                  setState(() {
                    _description = value;
                  });
                },
              ),
              const SizedBox(height: 16.0),
              TextButton(
                onPressed: () async {
                  final newDateTime = await showDatePicker(
                    context: context,
                    initialDate: _dateTime,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (newDateTime != null) {
                    setState(() {
                      _dateTime = newDateTime;
                    });
                  }
                },
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today),
                    const SizedBox(width: 8.0),
                    Text(DateFormat.yMd().format(_dateTime)),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              TextButton(
                onPressed: () async {
                  final newTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.fromDateTime(_dateTime),
                  );
                  if (newTime != null) {
                    setState(() {
                      _dateTime = DateTime(
                        _dateTime.year,
                        _dateTime.month,
                        _dateTime.day,
                        newTime.hour,
                        newTime.minute,
                      );
                    });
                  }
                },
                child: Row(
                  children: [
                    const Icon(Icons.alarm),
                    const SizedBox(width: 8.0),
                    Text(DateFormat.jm().format(_dateTime)),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // save data and close dialog
              
              notificationService.sendNotification(_name
              , _dosage);
                 
                    }
                  },
                  child: const Text('Save Reminder'),
                ),
              ),
            ],
          ),
        ),
      ),
    );}}