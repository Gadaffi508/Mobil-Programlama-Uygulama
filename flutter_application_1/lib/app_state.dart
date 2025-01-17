import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  List<Map<String, dynamic>> tasks = [];
  List<String> notes = [];
  List<Map<String, dynamic>> reminders = [];
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  void addTask(String task) {
    tasks.add({'task': task, 'isCompleted': false});
    notifyListeners();
  }

  void removeTask(int index) {
    tasks.removeAt(index);
    notifyListeners();
  }

  void toggleTaskCompletion(int index) {
    tasks[index]['isCompleted'] = !tasks[index]['isCompleted'];
    notifyListeners();
  }

  void addNote(String note) {
    notes.add(note);
    notifyListeners();
  }

  void removeNote(int index) {
    notes.removeAt(index);
    notifyListeners();
  }

  void addReminder(String text, TimeOfDay time) {
    reminders.add({
      'text': text,
      'time': time,
      'completed': false,
    });
    notifyListeners();
  }

  void removeReminder(int index) {
    reminders.removeAt(index);
    notifyListeners();
  }

  void toggleReminderCompletion(int index) {
    reminders[index]['completed'] = !reminders[index]['completed'];
    notifyListeners();
  }
}
