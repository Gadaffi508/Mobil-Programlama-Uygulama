// home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';
import 'task_list_screen.dart';
import 'notes_screen.dart';
import 'reminders_screen.dart';
import 'weather_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kişisel Asistan'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menü',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.task),
              title: Text('Görevler'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TaskListScreen()),
              ),
            ),
            ListTile(
              leading: Icon(Icons.notes),
              title: Text('Notlar'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotesScreen()),
              ),
            ),
            ListTile(
              leading: Icon(Icons.alarm),
              title: Text('Hatırlatıcılar'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RemindersScreen()),
              ),
            ),
            ListTile(
              leading: Icon(Icons.cloud),
              title: Text('Hava Durumu'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => WeatherScreen()),
              ),
            ),ListTile(
              leading: Icon(Icons.brightness_6),
              title: Text('Tema Değiştir'),
              trailing: Consumer<AppState>(
                builder: (context, appState, child) {
                  return Switch(
                    value: appState.themeMode == ThemeMode.dark,
                    onChanged: (value) {
                      appState.toggleTheme();
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      body: Consumer<AppState>(
        builder: (context, appState, child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Görevler', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: appState.tasks.length,
                    itemBuilder: (context, index) => ListTile(
                      title: Text(
                        appState.tasks[index]['task'],
                        style: TextStyle(
                          decoration: appState.tasks[index]['isCompleted'] ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      leading: Checkbox(
                        value: appState.tasks[index]['isCompleted'],
                        onChanged: (value) => appState.toggleTaskCompletion(index),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => appState.removeTask(index),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text('Notlar', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: appState.notes.length,
                    itemBuilder: (context, index) => ListTile(
                      title: Text(appState.notes[index]),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => appState.removeNote(index),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text('Hatırlatıcılar', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: appState.reminders.length,
                    itemBuilder: (context, index) => ListTile(
                      title: Text(appState.reminders[index]['text']),
                      subtitle: Text('Zaman: ${appState.reminders[index]['time']}'),
                      leading: Checkbox(
                        value: appState.reminders[index]['completed'],
                        onChanged: (value) => appState.toggleReminderCompletion(index),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => appState.removeReminder(index),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
