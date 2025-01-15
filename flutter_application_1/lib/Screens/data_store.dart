class DataStore {
  // Singleton instance
  static final DataStore _instance = DataStore._internal();

  factory DataStore() => _instance;

  DataStore._internal();

  // Verileri tutacak listeler
  List<Map<String, dynamic>> tasks = [];
  List<String> notes = [];
  List<Map<String, dynamic>> reminders = [];
}
