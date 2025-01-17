// task_list_screen.dart

import 'package:flutter/material.dart'; // Material tasarım bileşenleri ve widget'ları içerir.
import 'package:provider/provider.dart'; // State yönetimi için Provider kütüphanesini kullanır.
import '../app_state.dart'; // Uygulama durumunu yöneten AppState sınıfını içe aktarır.

class TaskListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Ekranın üst kısmındaki çubuk.
        title: Text('Görevler'), // Çubuğun başlığı.
      ),
      body: Consumer<AppState>(
        // Uygulama durumunu dinleyen bir Consumer widget'ı.
        builder: (context, appState, child) {
          return Column(
            // Görevler listesi ve "Görev Ekle" butonunu içeren bir sütun.
            children: [
              Expanded(
                // Görevleri listeleyen bir ListView widget'ını genişletir.
                child: ListView.builder(
                  itemCount: appState.tasks.length, // Görev sayısına göre liste uzunluğu.
                  itemBuilder: (context, index) => ListTile(
                    title: Text(
                      appState.tasks[index]['task'], // Görev metni.
                      style: TextStyle(
                        decoration: appState.tasks[index]['isCompleted']
                            ? TextDecoration.lineThrough // Tamamlanmış görev için üstü çizili metin.
                            : null,
                      ),
                    ),
                    leading: Checkbox(
                      // Görev tamamlama durumunu göstermek için bir Checkbox.
                      value: appState.tasks[index]['isCompleted'], // Görev tamamlanma durumu.
                      onChanged: (value) => appState.toggleTaskCompletion(index), // Durumu değiştirir.
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red), // Silme simgesi.
                      onPressed: () => appState.removeTask(index), // Görevi siler.
                    ),
                  ),
                ),
              ),
              Padding(
                // "Görev Ekle" butonuna padding ekler.
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  // Yeni bir görev eklemek için kullanılan buton.
                  onPressed: () async {
                    final task = await showDialog<String>(
                      // Kullanıcıdan görev adı girişi almak için bir diyalog açar.
                      context: context,
                      builder: (context) => _TaskInputDialog(), // Görev giriş diyalogu.
                    );
                    if (task != null && task.isNotEmpty) {
                      // Eğer kullanıcı bir görev girmişse.
                      appState.addTask(task); // Görevi ekler.
                    }
                  },
                  child: Text('Görev Ekle'), // Buton metni.
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
  final TextEditingController _controller = TextEditingController(); // Kullanıcının girişini kontrol eder.

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      // Görev girişi için bir diyalog kutusu.
      title: Text('Yeni Görev'), // Diyalog başlığı.
      content: TextField(
        // Kullanıcıdan metin girişi almak için bir TextField.
        controller: _controller, // Giriş kontrolcüsü.
        decoration: InputDecoration(hintText: 'Görev adı'), // Giriş için ipucu metni.
      ),
      actions: [
        TextButton(
          // İptal butonu.
          onPressed: () => Navigator.pop(context), // Diyalogdan çıkış yapar.
          child: Text('İptal'), // Buton metni.
        ),
        TextButton(
          // Ekle butonu.
          onPressed: () => Navigator.pop(context, _controller.text), // Girilen metni diyaloğu kapatarak döner.
          child: Text('Ekle'), // Buton metni.
        ),
      ],
    );
  }
}
