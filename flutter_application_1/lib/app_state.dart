import 'package:flutter/material.dart'; // Material tasarım bileşenlerini ve widget'ları içerir.

// AppState sınıfı, uygulama durumunu (state) yönetir ve değişiklikleri dinleyicilere bildirir.
class AppState extends ChangeNotifier {
  List<Map<String, dynamic>> tasks = []; // Görevlerin tutulduğu bir liste. Her görev bir harita (map) olarak saklanır.
  List<String> notes = []; // Notların tutulduğu bir liste. Notlar yalnızca metin olarak saklanır.
  List<Map<String, dynamic>> reminders = []; // Hatırlatıcıların tutulduğu bir liste. Her hatırlatıcı bir harita olarak saklanır.
  ThemeMode _themeMode = ThemeMode.system; // Varsayılan olarak sistem teması kullanılır.

  // Tema modunu dışarıya döndüren getter.
  ThemeMode get themeMode => _themeMode;

  // Tema modunu açık ve karanlık mod arasında değiştiren metot.
  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light; // Tema modunu tersine çevirir.
    notifyListeners(); // Dinleyicilere durum değişikliğini bildirir.
  }

  // Yeni bir görev ekler.
  void addTask(String task) {
    tasks.add({'task': task, 'isCompleted': false}); // Görev bilgisi (metin) ve tamamlanma durumu eklenir.
    notifyListeners(); // Dinleyicilere durum değişikliğini bildirir.
  }

  // Belirtilen indeksteki görevi siler.
  void removeTask(int index) {
    tasks.removeAt(index); // Görevler listesinden belirtilen indeksteki görevi kaldırır.
    notifyListeners(); // Dinleyicilere durum değişikliğini bildirir.
  }

  // Görevin tamamlanma durumunu değiştirir.
  void toggleTaskCompletion(int index) {
    tasks[index]['isCompleted'] = !tasks[index]['isCompleted']; // Tamamlama durumunu tersine çevirir.
    notifyListeners(); // Dinleyicilere durum değişikliğini bildirir.
  }

  // Yeni bir not ekler.
  void addNote(String note) {
    notes.add(note); // Notu notlar listesine ekler.
    notifyListeners(); // Dinleyicilere durum değişikliğini bildirir.
  }

  // Belirtilen indeksteki notu siler.
  void removeNote(int index) {
    notes.removeAt(index); // Notlar listesinden belirtilen indeksteki notu kaldırır.
    notifyListeners(); // Dinleyicilere durum değişikliğini bildirir.
  }

  // Yeni bir hatırlatıcı ekler.
  void addReminder(String text, TimeOfDay time) {
    reminders.add({
      'text': text, // Hatırlatıcının metni.
      'time': time, // Hatırlatıcının zamanı.
      'completed': false, // Varsayılan olarak tamamlanmamış durumu.
    });
    notifyListeners(); // Dinleyicilere durum değişikliğini bildirir.
  }

  // Belirtilen indeksteki hatırlatıcıyı siler.
  void removeReminder(int index) {
    reminders.removeAt(index); // Hatırlatıcılar listesinden belirtilen indeksteki hatırlatıcıyı kaldırır.
    notifyListeners(); // Dinleyicilere durum değişikliğini bildirir.
  }

  // Hatırlatıcının tamamlanma durumunu değiştirir.
  void toggleReminderCompletion(int index) {
    reminders[index]['completed'] = !reminders[index]['completed']; // Tamamlama durumunu tersine çevirir.
    notifyListeners(); // Dinleyicilere durum değişikliğini bildirir.
  }
}
