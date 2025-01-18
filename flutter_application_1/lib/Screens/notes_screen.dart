// notes_screen.dart

import 'package:flutter/material.dart'; // Material tasarım bileşenleri ve widget'ları içerir.
import 'package:provider/provider.dart'; // State yönetimi için Provider kütüphanesini kullanır.
import '../app_state.dart'; // Uygulama durumunu yöneten AppState sınıfını içe aktarır.

// Notlar ekranını temsil eden StatelessWidget sınıfı.
class NotesScreen extends StatelessWidget {
  @override
  //Widget, Flutter'da kullanıcı arayüzünün yapı taşı olup, görsel elemanlar (buton, metin, resim) veya davranışsal yapılar (düzenleme, kaydırma) gibi her şeyi temsil eder.
  Widget build(BuildContext context) {
    return Scaffold( // Ekranın temel düzen yapısını oluşturur.
      appBar: AppBar( // Ekranın üst kısmındaki uygulama çubuğu.
        title: Text('Notlar'), // Uygulama çubuğunun başlığı.
      ),
      body: Consumer<AppState>( // Uygulama durumunu dinleyen bir Consumer widget'ı.
        builder: (context, appState, child) { // AppState içindeki değişikliklere tepki verir.
          return Column( // Notlar listesini ve "Not Ekle" butonunu içeren bir sütun.
            children: [
              Expanded( // Sütunun içinde kalan alanı dolduracak bir widget.
                child: ListView.builder( // Notları listelemek için kullanılan bir ListView.
                  itemCount: appState.notes.length, // Listedeki not sayısını belirler.
                  itemBuilder: (context, index) => ListTile( // Her not için bir liste öğesi oluşturur.
                    title: Text(appState.notes[index]), // Liste öğesindeki not metni.
                    trailing: IconButton( // Notu silmek için bir buton.
                      icon: Icon(Icons.delete, color: Colors.red), // Silme simgesi.
                      onPressed: () => appState.removeNote(index), // Notu siler.
                    ),
                  ),
                ),
              ),
              Padding( // "Not Ekle" butonuna kenar boşluğu ekler.
                padding: const EdgeInsets.all(8.0), // Kenar boşluğu miktarı.
                child: ElevatedButton( // Yükseltilmiş bir buton (Material tasarımı).
                  onPressed: () async { // Butona tıklandığında çalışacak asenkron fonksiyon.
                    final note = await showDialog<String>( // Kullanıcıdan girdi almak için diyalog açar.
                      context: context,
                      builder: (context) => _NoteInputDialog(), // Not girişi için özel bir diyalog widget'ı.
                    );
                    if (note != null && note.isNotEmpty) { // Eğer bir not girilmişse ve boş değilse.
                      appState.addNote(note); // Yeni notu ekler.
                    }
                  },
                  child: Text('Not Ekle'), // Butonun üzerinde görünen metin.
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
  final TextEditingController _controller = TextEditingController(); // Kullanıcının girdiğini kontrol etmek için bir TextEditingController.

  @override
  Widget build(BuildContext context) {
    return AlertDialog( // Girdi almak için bir diyalog kutusu.
      title: Text('Yeni Not'), // Diyalog başlığı.
      content: TextField( // Kullanıcıdan metin girişi almak için bir TextField.
        controller: _controller, // Kullanıcının girdiği metni kontrol eden kontrolcü.
        decoration: InputDecoration(hintText: 'Not'), // Metin alanında görünen ipucu metni.
      ),
      actions: [ // Diyalog kutusunun alt kısmındaki butonlar.
        TextButton( // İptal butonu.
          onPressed: () => Navigator.pop(context), // Diyalog kutusunu kapatır.
          child: Text('İptal'), // Buton üzerinde görünen metin.
        ),
        TextButton( // Ekle butonu.
          onPressed: () => Navigator.pop(context, _controller.text), // Girilen metni diyaloğu kapatarak döner.
          child: Text('Ekle'), // Buton üzerinde görünen metin.
        ),
      ],
    );
  }
}
