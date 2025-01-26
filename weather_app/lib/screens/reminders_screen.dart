import 'package:flutter/material.dart';
import '../services/reminders_service.dart';

class RemindersScreen extends StatefulWidget {
  @override
  _RemindersScreenState createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen> {
  List<Map<String, dynamic>> reminders = [];
  bool isLoading = false;
  String selectedMessage = '';
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  final predefinedMessages = [
    "Bring an umbrella tomorrow",
    "Wear a jacket",
    "Sunny day ahead—stay hydrated",
    "Expect strong winds—be prepared",
    "Check for snowfall updates"
  ];

  @override
  void initState() {
    super.initState();
    fetchReminders();
  }

  void fetchReminders() async {
    setState(() => isLoading = true);
    final data = await ReminderService().getReminders();
    setState(() {
      reminders = data ?? [];
      isLoading = false;
    });
  }

  void createOrUpdateReminder(String? id) async {
    if (selectedMessage.isEmpty || selectedDate == null || selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select a message, date, and time.")),
      );
      return;
    }

    // Combine selected date and time into a single DateTime
    final dateTime = DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
      selectedTime!.hour,
      selectedTime!.minute,
    );

    // Convert to UTC for consistency
    final utcDateTime = dateTime.toUtc().toIso8601String();

    bool success;
    if (id == null) {
      // Create a new reminder
      success = await ReminderService().createReminder(selectedMessage, utcDateTime);
    } else {
      // Update an existing reminder
      success = await ReminderService().updateReminder(id, selectedMessage, utcDateTime);
    }

    if (success) {
      fetchReminders();
      Navigator.pop(context); // Close the dialog after creation/update
    }
  }

  void showAddOrEditDialog({String? id, String? initialMessage, DateTime? initialDateTime}) {
    if (id != null) {
      // Prepopulate values for editing
      selectedMessage = initialMessage!;
      selectedDate = initialDateTime!;
      selectedTime = TimeOfDay.fromDateTime(initialDateTime);
    } else {
      // Reset values for adding a new reminder
      selectedMessage = '';
      selectedDate = null;
      selectedTime = null;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(id == null ? 'Add Reminder' : 'Edit Reminder'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Dropdown for predefined messages
              DropdownButtonFormField<String>(
                value: selectedMessage.isNotEmpty ? selectedMessage : null,
                hint: Text("Select a reminder message"),
                onChanged: (value) {
                  setState(() {
                    selectedMessage = value!;
                  });
                },
                items: predefinedMessages.map((message) {
                  return DropdownMenuItem(
                    value: message,
                    child: Text(message),
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              // Date Picker Button
              ElevatedButton(
                onPressed: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: selectedDate ?? DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (date != null) {
                    setState(() {
                      selectedDate = date;
                    });
                  }
                },
                child: Text(
                  selectedDate != null
                      ? "Selected Date: ${selectedDate!.toLocal()}".split(' ')[0]
                      : "Pick a date",
                ),
              ),
              SizedBox(height: 10),
              // Time Picker Button
              ElevatedButton(
                onPressed: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: selectedTime ?? TimeOfDay.now(),
                  );
                  if (time != null) {
                    setState(() {
                      selectedTime = time;
                    });
                  }
                },
                child: Text(
                  selectedTime != null
                      ? "Selected Time: ${selectedTime!.format(context)}"
                      : "Pick a time",
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => createOrUpdateReminder(id),
              child: Text(id == null ? 'Add Reminder' : 'Save Changes'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Reminders')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: reminders.length,
              itemBuilder: (context, index) {
                final reminder = reminders[index];
                final dateTime = DateTime.parse(reminder['date']).toLocal();
                return ListTile(
                  title: Text(reminder['title']),
                  subtitle: Text(
                      "${dateTime.toLocal().toString().split(' ')[0]} at ${TimeOfDay.fromDateTime(dateTime).format(context)}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => showAddOrEditDialog(
                          id: reminder['_id'],
                          initialMessage: reminder['title'],
                          initialDateTime: dateTime,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          await ReminderService().deleteReminder(reminder['_id']);
                          fetchReminders();
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddOrEditDialog(),
        child: Icon(Icons.add),
        tooltip: 'Add Reminder',
      ),
    );
  }
}
