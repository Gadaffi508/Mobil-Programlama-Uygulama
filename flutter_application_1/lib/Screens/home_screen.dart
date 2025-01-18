// home_screen.dart

import 'package:flutter/material.dart'; // Material tasarım bileşenleri ve widget'ları içerir.
import 'package:provider/provider.dart'; // State yönetimi için Provider kütüphanesini kullanır.
import '../app_state.dart'; // AppState sınıfını içe aktarır.
import 'task_list_screen.dart'; // Görevler ekranını içe aktarır.
import 'notes_screen.dart'; // Notlar ekranını içe aktarır.
import 'reminders_screen.dart'; // Hatırlatıcılar ekranını içe aktarır.
import 'weather_screen.dart'; // Hava durumu ekranını içe aktarır.

class HomeScreen extends StatelessWidget { // Ana ekran widget'ı, statik ve değişmeyen UI için StatelessWidget kullanır.
  @override
  //Widget, Flutter'da kullanıcı arayüzünün yapı taşı olup, görsel elemanlar (buton, metin, resim) veya davranışsal yapılar (düzenleme, kaydırma) gibi her şeyi temsil eder.
  Widget build(BuildContext context) { // Widget'ın UI'ını oluşturan build metodu.
    return Scaffold( // Temel düzen yapısını oluşturur; AppBar, Drawer ve Body içerir.
      appBar: AppBar( // Uygulamanın üst kısmındaki başlık çubuğu.
        title: Text('Kişisel Asistan'), // Başlık çubuğundaki metin.
      ),
      drawer: Drawer( // Yan menü (Drawer) tanımı.
        child: ListView( // Menü öğelerini dikey liste olarak düzenler.
          padding: EdgeInsets.zero, // Varsayılan padding'i sıfırlar.
          children: [ // Liste elemanları.
            DrawerHeader( // Yan menü başlığı.
              decoration: BoxDecoration( // Görsel stil ayarları.
                color: Colors.blue, // Arka plan rengi mavi.
              ),
              child: Text( // Menü başlığı metni.
                'Menü', // Gösterilen metin.
                style: TextStyle( // Metin stili.
                  color: Colors.white, // Yazı rengi beyaz.
                  fontSize: 24, // Yazı boyutu.
                ),
              ),
            ),
            ListTile( // Görevler ekranına geçiş için bir liste öğesi.
              leading: Icon(Icons.task), // Görevler simgesi.
              title: Text('Görevler'), // Liste öğesi başlığı.
              onTap: () => Navigator.push( // Görevler ekranına yönlendirme.
                context,
                MaterialPageRoute(builder: (context) => TaskListScreen()), // Görevler ekranına geçiş yolu.
              ),
            ),
            ListTile( // Notlar ekranına geçiş için bir liste öğesi.
              leading: Icon(Icons.notes), // Notlar simgesi.
              title: Text('Notlar'), // Liste öğesi başlığı.
              onTap: () => Navigator.push( // Notlar ekranına yönlendirme.
                context,
                MaterialPageRoute(builder: (context) => NotesScreen()), // Notlar ekranına geçiş yolu.
              ),
            ),
            ListTile( // Hatırlatıcılar ekranına geçiş için bir liste öğesi.
              leading: Icon(Icons.alarm), // Hatırlatıcılar simgesi.
              title: Text('Hatırlatıcılar'), // Liste öğesi başlığı.
              onTap: () => Navigator.push( // Hatırlatıcılar ekranına yönlendirme.
                context,
                MaterialPageRoute(builder: (context) => RemindersScreen()), // Hatırlatıcılar ekranına geçiş yolu.
              ),
            ),
            ListTile( // Hava durumu ekranına geçiş için bir liste öğesi.
              leading: Icon(Icons.cloud), // Hava durumu simgesi.
              title: Text('Hava Durumu'), // Liste öğesi başlığı.
              onTap: () => Navigator.push( // Hava durumu ekranına yönlendirme.
                context,
                MaterialPageRoute(builder: (context) => WeatherScreen()), // Hava durumu ekranına geçiş yolu.
              ),
            ),
            ListTile( // Tema değiştirme için bir liste öğesi.
              leading: Icon(Icons.brightness_6), // Tema simgesi.
              title: Text('Tema Değiştir'), // Tema değiştirme öğesi başlığı.
              trailing: Consumer<AppState>( // Tema durumunu dinleyen bir Consumer widget'ı.
                builder: (context, appState, child) {
                  return Switch( // Tema değişikliği için bir anahtar.
                    value: appState.themeMode == ThemeMode.dark, // Şu anki tema durumunu kontrol eder.
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
      body: Consumer<AppState>( // Uygulama durumunu dinleyen Consumer widget.
        builder: (context, appState, child) { // AppState'teki değişikliklere tepki verir.
          return Padding( // İçeriğe kenar boşlukları ekler.
            padding: const EdgeInsets.all(16.0), // Kenar boşluğu değeri.
            child: SingleChildScrollView( // Kaydırılabilir bir ekran sağlar.
              child: Column( // Ekran içeriğini dikey düzenler.
                crossAxisAlignment: CrossAxisAlignment.start, // İçeriği sola hizalar.
                children: [
                  Text( // Görevler başlığı.
                    'Görevler', 
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), // Metin stili.
                  ),
                  ListView.builder( // Görevler listesini oluşturur.
                    shrinkWrap: true, // İçeriği boyutuna göre sıkıştırır.
                    physics: NeverScrollableScrollPhysics(), // Kaydırma özelliğini devre dışı bırakır.
                    itemCount: appState.tasks.length, // Görev sayısını belirler.
                    itemBuilder: (context, index) => ListTile( // Her bir görev için bir liste öğesi.
                      title: Text(
                        appState.tasks[index]['task'], // Görev metni.
                        style: TextStyle(
                          decoration: appState.tasks[index]['isCompleted'] ? TextDecoration.lineThrough : null, // Tamamlanmış görevler için üstü çizili metin.
                        ),
                      ),
                      leading: Checkbox( // Görev tamamlanma durumunu kontrol eden bir kutucuk.
                        value: appState.tasks[index]['isCompleted'], // Tamamlanma durumu.
                        onChanged: (value) => appState.toggleTaskCompletion(index), // Durumu değiştirir.
                      ),
                      trailing: IconButton( // Görevi silmek için bir düğme.
                        icon: Icon(Icons.delete, color: Colors.red), // Silme simgesi.
                        onPressed: () => appState.removeTask(index), // Görevi siler.
                      ),
                    ),
                  ),
                  SizedBox(height: 10), // Görevler ve notlar arasına boşluk ekler.
                  Text( // Notlar başlığı.
                    'Notlar', 
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), // Metin stili.
                  ),
                  ListView.builder( // Notlar listesini oluşturur.
                    shrinkWrap: true, 
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: appState.notes.length, // Not sayısını belirler.
                    itemBuilder: (context, index) => ListTile( // Her bir not için bir liste öğesi.
                      title: Text(appState.notes[index]), // Not metni.
                      trailing: IconButton( // Notu silmek için bir düğme.
                        icon: Icon(Icons.delete, color: Colors.red), // Silme simgesi.
                        onPressed: () => appState.removeNote(index), // Notu siler.
                      ),
                    ),
                  ),
                  SizedBox(height: 10), // Notlar ve hatırlatıcılar arasına boşluk ekler.
                  Text( // Hatırlatıcılar başlığı.
                    'Hatırlatıcılar', 
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), // Metin stili.
                  ),
                  ListView.builder( // Hatırlatıcılar listesini oluşturur.
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: appState.reminders.length, // Hatırlatıcı sayısını belirler.
                    itemBuilder: (context, index) => ListTile( // Her bir hatırlatıcı için bir liste öğesi.
                      title: Text(appState.reminders[index]['text']), // Hatırlatıcı metni.
                      subtitle: Text('Zaman: ${appState.reminders[index]['time']}'), // Hatırlatıcı zamanı.
                      leading: Checkbox( // Hatırlatıcı tamamlanma durumunu kontrol eden kutucuk.
                        value: appState.reminders[index]['completed'], // Tamamlanma durumu.
                        onChanged: (value) => appState.toggleReminderCompletion(index), // Durumu değiştirir.
                      ),
                      trailing: IconButton( // Hatırlatıcıyı silmek için bir düğme.
                        icon: Icon(Icons.delete, color: Colors.red), // Silme simgesi.
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
