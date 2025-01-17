// notes_screen.dart

import 'package:flutter/material.dart'; // Material tasarım bileşenleri ve widget'ları içerir.
import 'package:provider/provider.dart'; // State yönetimi için Provider kütüphanesini kullanır.
import '../app_state.dart'; // Uygulama durumunu yöneten AppState sınıfını içe aktarır.

class NotesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Ekranın üst kısmındaki uygulama çubuğu.
        title: Text('Notlar'), // Çubuğun başlığı.
      ),
      body: Consumer<AppState>(
        // Uygulama durumunu dinleyen bir Consumer widget'ı.
        builder: (context, appState, child) {
          return Column(
            // Notlar ve "Not Ekle" butonunu içeren bir sütun.
            children: [
              Expanded(
                // Notları listeleyen bir ListView widget'ını genişletir.
                child: ListView.builder(
                  itemCount: appState.notes.length, // Not sayısına göre liste uzunluğu.
                  itemBuilder: (context, index) => ListTile(
                    title: Text(appState.notes[index]), // Notun metni.
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red), // Silme simgesi.
                      onPressed: () => appState.removeNote(index), // Notu siler.
                    ),
                  ),
                ),
              ),
              Padding(
                // "Not Ekle" butonuna padding ekler.
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  // Yeni bir not eklemek için kullanılan buton.
                  onPressed: () async {
                    // Kullanıcıdan not almak için bir diyalog açar.
                    final note = await showDialog<String>(
                      context: context,
                      builder: (context) => _NoteInputDialog(), // Not giriş diyalogu.
                    );
                    if (note != null && note.isNotEmpty) {
                      // Eğer kullanıcı bir not girmişse.
                      appState.addNote(note); // Notu ekler.
                    }
                  },
                  child: Text('Not Ekle'), // Buton metni.
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// Kullanıcıdan not almak için kullanılan özel bir diyalog sınıfı.
class _NoteInputDialog extends StatelessWidget {
  final TextEditingController _controller = TextEditingController(); // Kullanıcının girdiğini almak için bir TextEditingController.

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      // Girdi almak için bir diyalog kutusu.
      title: Text('Yeni Not'), // Diyalog başlığı.
      content: TextField(
        // Kullanıcıdan metin girişi almak için bir TextField.
        controller: _controller, // Giriş kontrolcüsü.
        decoration: InputDecoration(hintText: 'Not'), // Giriş için ipucu metni.
      ),
      actions: [
        TextButton(
          // İptal butonu.
          onPressed: () => Navigator.pop(context), // Diyalogdan çıkış yapar.
          child: Text('İptal'), // Buton metni.
        ),
        TextButton(
          // Ekle butonu.
          onPressed: () => Navigator.pop(context, _controller.text), // Girilen notu diyaloğu kapatarak döner.
          child: Text('Ekle'), // Buton metni.
        ),
      ],
    );
  }
}
