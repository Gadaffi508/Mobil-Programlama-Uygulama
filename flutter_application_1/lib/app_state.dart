import 'package:flutter/material.dart';

// AppState sınıfı, uygulama durumunu (state) yönetir ve değişiklikleri dinleyicilere bildirir.
class AppState extends ChangeNotifier {
  List<Map<String, dynamic>> tasks = []; // Görevlerin tutulduğu bir liste.
  List<String> notes = []; // Notların tutulduğu bir liste.
  List<Map<String, dynamic>> reminders = []; // Hatırlatıcıların tutulduğu bir liste.
  ThemeMode _themeMode = ThemeMode.system; // Varsayılan olarak sistem teması.

  // Tema modunu dışarıya döndüren getter.
  ThemeMode get themeMode => _themeMode;

  // Tema modunu açık ve karanlık mod arasında değiştiren metot.
  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners(); // Dinleyicilere durum değişikliğini bildirir.
  }

  // Yeni bir görev ekler.
  void addTask(String task) {
    tasks.add({'task': task, 'isCompleted': false}); // Görev bilgisi ve tamamlanma durumu.
    notifyListeners(); // Dinleyicilere durum değişikliğini bildirir.
  }

  // Belirtilen indeksteki görevi siler.
  void removeTask(int index) {
    tasks.removeAt(index); 
    notifyListeners();
  }

  // Görevin tamamlanma durumunu değiştirir.
  void toggleTaskCompletion(int index) {
    tasks[index]['isCompleted'] = !tasks[index]['isCompleted'];
    notifyListeners();
  }

  // Yeni bir not ekler.
  void addNote(String note) {
    notes.add(note);
    notifyListeners();
  }

  // Belirtilen indeksteki notu siler.
  void removeNote(int index) {
    notes.removeAt(index);
    notifyListeners();
  }

  // Yeni bir hatırlatıcı ekler.
  void addReminder(String text, TimeOfDay time) {
    reminders.add({
      'text': text, // Hatırlatıcının metni.
      'time': time, // Hatırlatıcının zamanı.
      'completed': false, // Tamamlanma durumu.
    });
    notifyListeners();
  }

  // Belirtilen indeksteki hatırlatıcıyı siler.
  void removeReminder(int index) {
    reminders.removeAt(index);
    notifyListeners();
  }

  // Hatırlatıcının tamamlanma durumunu değiştirir.
  void toggleReminderCompletion(int index) {
    reminders[index]['completed'] = !reminders[index]['completed'];
    notifyListeners();
  }
}
