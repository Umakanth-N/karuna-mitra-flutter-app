import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;


  class Reminder {
  final String name;
  final String description;
  final DateTime dateTime;

  Reminder(this.name, this.description, this.dateTime);
}



class RemainderScreen extends StatefulWidget {
  const RemainderScreen({super.key});

  @override
  _RemainderScreenState createState() => _RemainderScreenState();
}

class _RemainderScreenState extends State<RemainderScreen> {
  final List<Reminder> _reminders = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reminders'),
      ),
      body: ListView.builder(
        itemCount: _reminders.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(_reminders[index].name),
              subtitle: Text(_reminders[index].description),
              trailing: Text(_reminders[index].dateTime.toString()),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final reminder = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ReminderForm()),
          );
          if (reminder != null) {
            setState(() {
              _reminders.add(reminder);
            });
            await scheduleNotification(reminder);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  // Define a function to schedule a notification for a reminder
  Future<void> scheduleNotification(Reminder reminder) async {
    const androidDetails = AndroidNotificationDetails(
      'channel_id',
      'channel_name',

      importance: Importance.high,
      priority: Priority.high,
      sound:RawResourceAndroidNotificationSound('noti'),
      ticker: 'ticker',
    );
    const platformDetails = NotificationDetails(android: androidDetails);
    final scheduledDate = tz.TZDateTime.from(reminder.dateTime, tz.local);
    await FlutterLocalNotificationsPlugin().zonedSchedule(
      0,
      reminder.name,
      reminder.description,
      scheduledDate,
      platformDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}

// Define a ReminderForm widget to display a form for adding a new reminder
class ReminderForm extends StatefulWidget {
  @override
  _ReminderFormState createState() => _ReminderFormState();
}

class _ReminderFormState extends State<ReminderForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _dateTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Reminder'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a description';
                }
                return null;
              },
            ),
            ListTile(
              title: const Text('Date'),
              subtitle: Text(_dateTime.toString()),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _dateTime,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (date != null) {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.fromDateTime(_dateTime),
                  );
                  if (time != null) {
                    setState(() {
                      _dateTime = DateTime(
                        date.year,
                        date.month,
                        date.day,
                        time.hour,
                        time.minute,
                      );
                    });
                  }
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final reminder = Reminder(
                      _nameController.text,
                      _descriptionController.text,
                      _dateTime,
                    );
                    Navigator.pop(context, reminder);
                  }
                },
                child: const Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}