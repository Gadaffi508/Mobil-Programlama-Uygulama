// home_screen.dart

import 'package:flutter/material.dart'; // Material tasarım bileşenleri ve widget'ları içerir.
import 'package:provider/provider.dart'; // State yönetimi için Provider kütüphanesini kullanır.
import '../app_state.dart'; // AppState sınıfını içe aktarır.
import 'task_list_screen.dart'; // Görevler ekranını içe aktarır.
import 'notes_screen.dart'; // Notlar ekranını içe aktarır.
import 'reminders_screen.dart'; // Hatırlatıcılar ekranını içe aktarır.
import 'weather_screen.dart'; // Hava durumu ekranını içe aktarır.

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kişisel Asistan'), // Uygulamanın başlığı.
      ),
      drawer: Drawer(
        // Yan menü (Drawer) tanımlaması.
        child: ListView(
          padding: EdgeInsets.zero, // Varsayılan padding'i sıfırlar.
          children: [
            DrawerHeader(
              // Menü başlığı için bir DrawerHeader.
              decoration: BoxDecoration(
                color: Colors.blue, // Arkaplan rengi mavi.
              ),
              child: Text(
                'Menü', // Menü başlığı metni.
                style: TextStyle(
                  color: Colors.white, // Yazı rengi beyaz.
                  fontSize: 24, // Yazı boyutu.
                ),
              ),
            ),
            ListTile(
              // Görevler ekranına geçiş için bir liste öğesi.
              leading: Icon(Icons.task), // Görevler simgesi.
              title: Text('Görevler'), // Liste başlığı.
              onTap: () => Navigator.push(
                // Görevler ekranına yönlendirme.
                context,
                MaterialPageRoute(builder: (context) => TaskListScreen()),
              ),
            ),
            ListTile(
              // Notlar ekranına geçiş için bir liste öğesi.
              leading: Icon(Icons.notes), // Notlar simgesi.
              title: Text('Notlar'), // Liste başlığı.
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotesScreen()),
              ),
            ),
            ListTile(
              // Hatırlatıcılar ekranına geçiş için bir liste öğesi.
              leading: Icon(Icons.alarm), // Hatırlatıcılar simgesi.
              title: Text('Hatırlatıcılar'), // Liste başlığı.
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RemindersScreen()),
              ),
            ),
            ListTile(
              // Hava durumu ekranına geçiş için bir liste öğesi.
              leading: Icon(Icons.cloud), // Hava durumu simgesi.
              title: Text('Hava Durumu'), // Liste başlığı.
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => WeatherScreen()),
              ),
            ),
            ListTile(
              // Tema değiştirme için bir liste öğesi.
              leading: Icon(Icons.brightness_6), // Tema simgesi.
              title: Text('Tema Değiştir'), // Liste başlığı.
              trailing: Consumer<AppState>(
                // Tema durumunu dinleyen bir Consumer widget'ı.
                builder: (context, appState, child) {
                  return Switch(
                    value: appState.themeMode == ThemeMode.dark, // Karanlık mod kontrolü.
                    onChanged: (value) {
                      appState.toggleTheme(); // Tema modunu değiştirir.
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      body: Consumer<AppState>(
        // Uygulama durumunu dinleyen bir Consumer widget'ı.
        builder: (context, appState, child) {
          return Padding(
            padding: const EdgeInsets.all(16.0), // Kenar boşluğu ekler.
            child: SingleChildScrollView(
              // Kaydırılabilir bir ekran sağlar.
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // Elemanları sola hizalar.
                children: [
                  // Görevler listesi başlığı.
                  Text('Görevler', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ListView.builder(
                    // Görevler listesi için bir ListView.
                    shrinkWrap: true, // ListView'ın tüm öğeleri göstermesini sağlar.
                    physics: NeverScrollableScrollPhysics(), // Kaydırma özelliğini devre dışı bırakır.
                    itemCount: appState.tasks.length, // Görev sayısı.
                    itemBuilder: (context, index) => ListTile(
                      title: Text(
                        appState.tasks[index]['task'], // Görev metni.
                        style: TextStyle(
                          decoration: appState.tasks[index]['isCompleted'] ? TextDecoration.lineThrough : null, // Tamamlanmış görev için üstü çizili metin.
                        ),
                      ),
                      leading: Checkbox(
                        // Görev tamamlama kontrolü.
                        value: appState.tasks[index]['isCompleted'],
                        onChanged: (value) => appState.toggleTaskCompletion(index), // Görev durumunu değiştirir.
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red), // Silme simgesi.
                        onPressed: () => appState.removeTask(index), // Görevi siler.
                      ),
                    ),
                  ),
                  SizedBox(height: 10), // Görevler ve notlar arasına boşluk ekler.
                  Text('Notlar', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), // Notlar başlığı.
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: appState.notes.length,
                    itemBuilder: (context, index) => ListTile(
                      title: Text(appState.notes[index]), // Not metni.
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red), // Not silme simgesi.
                        onPressed: () => appState.removeNote(index), // Notu siler.
                      ),
                    ),
                  ),
                  SizedBox(height: 10), // Notlar ve hatırlatıcılar arasına boşluk ekler.
                  Text('Hatırlatıcılar', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), // Hatırlatıcılar başlığı.
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: appState.reminders.length,
                    itemBuilder: (context, index) => ListTile(
                      title: Text(appState.reminders[index]['text']), // Hatırlatıcı metni.
                      subtitle: Text('Zaman: ${appState.reminders[index]['time']}'), // Hatırlatıcı zamanı.
                      leading: Checkbox(
                        value: appState.reminders[index]['completed'], // Hatırlatıcının tamamlanma durumu.
                        onChanged: (value) => appState.toggleReminderCompletion(index), // Tamamlanma durumunu değiştirir.
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red), // Hatırlatıcı silme simgesi.
                        onPressed: () => appState.removeReminder(index), // Hatırlatıcıyı siler.
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
