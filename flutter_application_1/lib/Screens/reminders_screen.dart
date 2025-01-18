// reminders_screen.dart

import 'package:flutter/material.dart'; // Material tasarım bileşenleri ve widget'ları içerir.
import 'package:provider/provider.dart'; // State yönetimi için Provider kütüphanesini kullanır.
import '../app_state.dart'; // Uygulama durumunu yöneten AppState sınıfını içe aktarır.

// Hatırlatıcılar ekranını temsil eden StatelessWidget sınıfı.
class RemindersScreen extends StatelessWidget {
  @override
  //Widget, Flutter'da kullanıcı arayüzünün yapı taşı olup, görsel elemanlar (buton, metin, resim) veya davranışsal yapılar (düzenleme, kaydırma) gibi her şeyi temsil eder.
  Widget build(BuildContext context) {
    return Scaffold( // Ekranın temel düzen yapısını oluşturur.
      appBar: AppBar( // Üst kısımdaki uygulama çubuğu.
        title: Text('Hatırlatıcılar'), // Uygulama çubuğunun başlığı.
      ),
      body: Consumer<AppState>( // Uygulama durumunu dinleyen bir Consumer widget.
        builder: (context, appState, child) { // AppState içindeki değişikliklere tepki verir.
          return Column( // Hatırlatıcılar listesi ve "Hatırlatıcı Ekle" butonunu içeren bir sütun.
            children: [
              Expanded( // Listeyi genişletir ve kalan alanı doldurur.
                child: ListView.builder( // Hatırlatıcıları listelemek için kullanılan bir ListView.
                  itemCount: appState.reminders.length, // Listedeki hatırlatıcı sayısını belirler.
                  itemBuilder: (context, index) {
                    final reminder = appState.reminders[index]; // Belirli bir hatırlatıcıyı alır.
                    return ListTile( // Her hatırlatıcı için bir liste öğesi oluşturur.
                      title: Text(reminder['text']), // Hatırlatıcı metni.
                      subtitle: Text('Zaman: ${reminder['time']}'), // Hatırlatıcı zamanı.
                      leading: Checkbox( // Hatırlatıcının tamamlanma durumunu gösteren Checkbox.
                        value: reminder['completed'], // Tamamlanma durumu.
                        onChanged: (value) => appState.toggleReminderCompletion(index), // Durumu değiştirir.
                      ),
                      trailing: IconButton( // Hatırlatıcıyı silmek için bir düğme.
                        icon: Icon(Icons.delete, color: Colors.red), // Silme simgesi.
                        onPressed: () => appState.removeReminder(index), // Hatırlatıcıyı siler.
                      ),
                    );
                  },
                ),
              ),
              Padding( // "Hatırlatıcı Ekle" butonuna kenar boşluğu ekler.
                padding: const EdgeInsets.all(8.0), // Kenar boşluğu miktarı.
                child: ElevatedButton( // Hatırlatıcı eklemek için kullanılan bir buton.
                  onPressed: () async { // Asenkron bir fonksiyon çalıştırır.
                    final result = await showDialog<Map<String, dynamic>>( // Hatırlatıcı girişi için bir diyalog açar.
                      context: context,
                      builder: (context) => _ReminderInputDialog(), // Giriş diyalogu widget'ı.
                    );
                    if (result != null) { // Eğer veri girilmişse.
                      appState.addReminder(result['text'], result['time']); // Yeni hatırlatıcı ekler.
                    }
                  },
                  child: Text('Hatırlatıcı Ekle'), // Buton üzerindeki metin.
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// Hatırlatıcı girişi almak için kullanılan StatefulWidget.
class _ReminderInputDialog extends StatefulWidget {
  @override
  _ReminderInputDialogState createState() => _ReminderInputDialogState(); // Gerekli state nesnesini oluşturur.
}

class _ReminderInputDialogState extends State<_ReminderInputDialog> {
  final TextEditingController _textController = TextEditingController(); // Kullanıcının metin girişini kontrol eder.
  TimeOfDay? _selectedTime; // Kullanıcının seçtiği zamanı tutar.

  Future<void> _pickTime() async { // Zaman seçimi için kullanılan bir metod.
    final time = await showTimePicker( // Zaman seçimi için bir diyalog açar.
      context: context, // Geçerli bağlam.
      initialTime: TimeOfDay.now(), // Varsayılan başlangıç zamanı.
    );
    if (time != null) { // Eğer kullanıcı bir zaman seçmişse.
      setState(() {
        _selectedTime = time; // Seçilen zamanı kaydeder.
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog( // Hatırlatıcı girişi için kullanılan diyalog kutusu.
      title: Text('Yeni Hatırlatıcı'), // Diyalog başlığı.
      content: Column( // Girdi bileşenlerini dikey sıralar.
        mainAxisSize: MainAxisSize.min, // İçeriğin minimum boyutta olmasını sağlar.
        children: [
          TextField( // Kullanıcıdan metin girişi almak için kullanılan bir TextField.
            controller: _textController, // Girişi kontrol eden kontrolcü.
            decoration: InputDecoration(hintText: 'Hatırlatıcı metni'), // Giriş alanı için ipucu metni.
          ),
          SizedBox(height: 10), // Metin girişi ile zaman seçici arasında boşluk ekler.
          Row(
            children: [
              ElevatedButton( // Zaman seçimi için kullanılan buton.
                onPressed: _pickTime, // Zaman seçimi işlemini başlatır.
                child: Text(
                  _selectedTime != null // Eğer zaman seçilmişse.
                      ? _selectedTime!.format(context) // Seçilen zamanı gösterir.
                      : 'Zaman Seç', // Zaman seçilmemişse varsayılan metin.
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [ // Diyalog kutusunun alt kısmındaki eylem düğmeleri.
        TextButton( // İptal butonu.
          onPressed: () => Navigator.pop(context), // Diyalog kutusunu kapatır.
          child: Text('İptal'), // Buton üzerindeki metin.
        ),
        TextButton( // Ekle butonu.
          onPressed: () {
            if (_textController.text.isNotEmpty && _selectedTime != null) { // Eğer metin boş değilse ve zaman seçilmişse.
              Navigator.pop(context, { // Girilen veriyi diyaloğu kapatarak döndürür.
                'text': _textController.text, // Hatırlatıcı metni.
                'time': _selectedTime!, // Seçilen zaman.
              });
            }
          },
          child: Text('Ekle'), // Buton üzerindeki metin.
        ),
      ],
    );
  }
}
