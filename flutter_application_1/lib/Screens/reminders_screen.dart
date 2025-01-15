// reminders_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';

class RemindersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hatırlatıcılar'),
      ),
      body: Consumer<AppState>(
        builder: (context, appState, child) {
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: appState.reminders.length,
                  itemBuilder: (context, index) {
                    final reminder = appState.reminders[index];
                    return ListTile(
                      title: Text(reminder['text']),
                      subtitle: Text('Zaman: ${reminder['time']}'),
                      leading: Checkbox(
                        value: reminder['completed'],
                        onChanged: (value) => appState.toggleReminderCompletion(index),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => appState.removeReminder(index),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () async {
                    final result = await showDialog<Map<String, dynamic>>(
                      context: context,
                      builder: (context) => _ReminderInputDialog(),
                    );
                    if (result != null) {
                      appState.addReminder(result['text'], result['time']);
                    }
                  },
                  child: Text('Hatırlatıcı Ekle'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ReminderInputDialog extends StatefulWidget {
  @override
  _ReminderInputDialogState createState() => _ReminderInputDialogState();
}

class _ReminderInputDialogState extends State<_ReminderInputDialog> {
  final TextEditingController _textController = TextEditingController();
  TimeOfDay? _selectedTime;

  Future<void> _pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null) {
      setState(() {
        _selectedTime = time;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Yeni Hatırlatıcı'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _textController,
            decoration: InputDecoration(hintText: 'Hatırlatıcı metni'),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              ElevatedButton(
                onPressed: _pickTime,
                child: Text(_selectedTime != null
                    ? _selectedTime!.format(context)
                    : 'Zaman Seç'),
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('İptal'),
        ),
        TextButton(
          onPressed: () {
            if (_textController.text.isNotEmpty && _selectedTime != null) {
              Navigator.pop(context, {
                'text': _textController.text,
                'time': _selectedTime!,
              });
            }
          },
          child: Text('Ekle'),
        ),
      ],
    );
  }
}
