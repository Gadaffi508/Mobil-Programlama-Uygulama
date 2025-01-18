// task_list_screen.dart

import 'package:flutter/material.dart'; // Material tasarım bileşenleri ve widget'ları içerir.
import 'package:provider/provider.dart'; // State yönetimi için Provider kütüphanesini kullanır.
import '../app_state.dart'; // Uygulama durumunu yöneten AppState sınıfını içe aktarır.

// Görevler ekranını temsil eden StatelessWidget sınıfı.
class TaskListScreen extends StatelessWidget {
  @override
  //Widget, Flutter'da kullanıcı arayüzünün yapı taşı olup, görsel elemanlar (buton, metin, resim) veya davranışsal yapılar (düzenleme, kaydırma) gibi her şeyi temsil eder.
  Widget build(BuildContext context) {
    return Scaffold( // Ekranın temel düzen yapısını oluşturur.
      appBar: AppBar( // Üst kısımdaki uygulama çubuğu.
        title: Text('Görevler'), // Uygulama çubuğunun başlığı.
      ),
      body: Consumer<AppState>( // Uygulama durumunu dinleyen bir Consumer widget.
        builder: (context, appState, child) { // AppState içindeki değişikliklere tepki verir.
          return Column( // Görevler listesi ve "Görev Ekle" butonunu içeren bir sütun.
            children: [
              Expanded( // Listeyi genişletir ve kalan alanı doldurur.
                child: ListView.builder( // Görevleri listelemek için kullanılan bir ListView.
                  itemCount: appState.tasks.length, // Listedeki görev sayısını belirler.
                  itemBuilder: (context, index) => ListTile( // Her görev için bir liste öğesi oluşturur.
                    title: Text(
                      appState.tasks[index]['task'], // Görev metni.
                      style: TextStyle(
                        decoration: appState.tasks[index]['isCompleted'] // Eğer görev tamamlanmışsa.
                            ? TextDecoration.lineThrough // Üstü çizili metin.
                            : null, // Tamamlanmamışsa normal metin.
                      ),
                    ),
                    leading: Checkbox( // Görev tamamlama durumunu gösteren Checkbox.
                      value: appState.tasks[index]['isCompleted'], // Görev tamamlanma durumu.
                      onChanged: (value) => appState.toggleTaskCompletion(index), // Tamamlama durumunu değiştirir.
                    ),
                    trailing: IconButton( // Görevi silmek için kullanılan bir düğme.
                      icon: Icon(Icons.delete, color: Colors.red), // Silme simgesi.
                      onPressed: () => appState.removeTask(index), // Görevi siler.
                    ),
                  ),
                ),
              ),
              Padding( // "Görev Ekle" butonuna kenar boşluğu ekler.
                padding: const EdgeInsets.all(8.0), // Kenar boşluğu miktarı.
                child: ElevatedButton( // Yeni bir görev eklemek için kullanılan bir buton.
                  onPressed: () async { // Asenkron bir fonksiyon çalıştırır.
                    final task = await showDialog<String>( // Görev girişi için bir diyalog açar.
                      context: context,
                      builder: (context) => _TaskInputDialog(), // Görev giriş diyalogu widget'ı.
                    );
                    if (task != null && task.isNotEmpty) { // Eğer görev metni boş değilse.
                      appState.addTask(task); // Yeni görevi ekler.
                    }
                  },
                  child: Text('Görev Ekle'), // Buton üzerindeki metin.
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// Görev girişi almak için kullanılan özel bir diyalog sınıfı.
class _TaskInputDialog extends StatelessWidget {
  final TextEditingController _controller = TextEditingController(); // Kullanıcının metin girişini kontrol eder.

  @override
  Widget build(BuildContext context) {
    return AlertDialog( // Görev girişi için kullanılan bir diyalog kutusu.
      title: Text('Yeni Görev'), // Diyalog başlığı.
      content: TextField( // Kullanıcıdan metin girişi almak için kullanılan bir TextField.
        controller: _controller, // Girişi kontrol eden kontrolcü.
        decoration: InputDecoration(hintText: 'Görev adı'), // Giriş alanı için ipucu metni.
      ),
      actions: [ // Diyalog kutusunun alt kısmındaki eylem düğmeleri.
        TextButton( // İptal butonu.
          onPressed: () => Navigator.pop(context), // Diyalog kutusunu kapatır.
          child: Text('İptal'), // Buton üzerindeki metin.
        ),
        TextButton( // Ekle butonu.
          onPressed: () => Navigator.pop(context, _controller.text), // Girilen metni diyaloğu kapatarak döndürür.
          child: Text('Ekle'), // Buton üzerindeki metin.
        ),
      ],
    );
  }
}
