import 'package:flutter/material.dart';
import '../screens/task_list_screen.dart';
import '../screens/notes_screen.dart';
import '../screens/reminders_screen.dart';
import '../screens/weather_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
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
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TaskListScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.notes),
            title: Text('Notlar'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotesScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.alarm),
            title: Text('Hatırlatıcılar'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RemindersScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.cloud),
            title: Text('Hava Durumu'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => WeatherScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}