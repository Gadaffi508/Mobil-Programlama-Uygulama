// reminders_screen.dart

import 'package:flutter/material.dart'; // Material tasarım bileşenleri ve widget'ları içerir.
import 'package:provider/provider.dart'; // State yönetimi için Provider kütüphanesini kullanır.
import '../app_state.dart'; // Uygulama durumunu yöneten AppState sınıfını içe aktarır.

class RemindersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Ekranın üst kısmındaki uygulama çubuğu.
        title: Text('Hatırlatıcılar'), // Çubuğun başlığı.
      ),
      body: Consumer<AppState>(
        // Uygulama durumunu dinleyen bir Consumer widget'ı.
        builder: (context, appState, child) {
          return Column(
            // Hatırlatıcılar listesi ve "Hatırlatıcı Ekle" butonunu içeren bir sütun.
            children: [
              Expanded(
                // Hatırlatıcıları listeleyen bir ListView widget'ını genişletir.
                child: ListView.builder(
                  itemCount: appState.reminders.length, // Hatırlatıcı sayısına göre liste uzunluğu.
                  itemBuilder: (context, index) {
                    final reminder = appState.reminders[index]; // Belirli bir hatırlatıcıyı alır.
                    return ListTile(
                      title: Text(reminder['text']), // Hatırlatıcı metni.
                      subtitle: Text('Zaman: ${reminder['time']}'), // Hatırlatıcı zamanı.
                      leading: Checkbox(
                        // Tamamlanma durumunu göstermek için bir Checkbox.
                        value: reminder['completed'], // Hatırlatıcı tamamlanma durumu.
                        onChanged: (value) => appState.toggleReminderCompletion(index), // Durumu değiştirir.
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red), // Silme simgesi.
                        onPressed: () => appState.removeReminder(index), // Hatırlatıcıyı siler.
                      ),
                    );
                  },
                ),
              ),
              Padding(
                // "Hatırlatıcı Ekle" butonuna padding ekler.
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  // Yeni bir hatırlatıcı eklemek için kullanılan buton.
                  onPressed: () async {
                    final result = await showDialog<Map<String, dynamic>>(
                      // Kullanıcıdan metin ve zaman girişi almak için bir diyalog açar.
                      context: context,
                      builder: (context) => _ReminderInputDialog(), // Hatırlatıcı giriş diyalogu.
                    );
                    if (result != null) {
                      // Eğer kullanıcı bir veri girmişse.
                      appState.addReminder(result['text'], result['time']); // Hatırlatıcıyı ekler.
                    }
                  },
                  child: Text('Hatırlatıcı Ekle'), // Buton metni.
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// Hatırlatıcı girişi almak için kullanılan özel bir StatefulWidget.
class _ReminderInputDialog extends StatefulWidget {
  @override
  _ReminderInputDialogState createState() => _ReminderInputDialogState(); // State nesnesi oluşturur.
}

class _ReminderInputDialogState extends State<_ReminderInputDialog> {
  final TextEditingController _textController = TextEditingController(); // Kullanıcının metin girişini kontrol eder.
  TimeOfDay? _selectedTime; // Kullanıcının seçtiği zaman.

  // Zaman seçici diyalog açan bir metot.
  Future<void> _pickTime() async {
    final time = await showTimePicker(
      context: context, // Geçerli bağlam.
      initialTime: TimeOfDay.now(), // Varsayılan olarak şimdiki zaman.
    );
    if (time != null) {
      // Eğer kullanıcı bir zaman seçmişse.
      setState(() {
        _selectedTime = time; // Seçilen zamanı kaydeder.
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      // Hatırlatıcı girişi için bir diyalog kutusu.
      title: Text('Yeni Hatırlatıcı'), // Diyalog başlığı.
      content: Column(
        mainAxisSize: MainAxisSize.min, // İçeriği minimum boyutta tutar.
        children: [
          TextField(
            // Kullanıcıdan metin girişi almak için bir TextField.
            controller: _textController, // Giriş kontrolcüsü.
            decoration: InputDecoration(hintText: 'Hatırlatıcı metni'), // Giriş için ipucu metni.
          ),
          SizedBox(height: 10), // Metin ve zaman seçimi arasında boşluk.
          Row(
            children: [
              ElevatedButton(
                // Zaman seçimi için kullanılan buton.
                onPressed: _pickTime, // Zaman seçme işlemi.
                child: Text(
                  _selectedTime != null
                      ? _selectedTime!.format(context) // Eğer zaman seçilmişse formatlanmış hali.
                      : 'Zaman Seç', // Zaman seçilmemişse varsayılan metin.
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          // İptal butonu.
          onPressed: () => Navigator.pop(context), // Diyalogdan çıkış yapar.
          child: Text('İptal'), // Buton metni.
        ),
        TextButton(
          // Ekle butonu.
          onPressed: () {
            if (_textController.text.isNotEmpty && _selectedTime != null) {
              // Eğer metin boş değilse ve zaman seçilmişse.
              Navigator.pop(context, {
                'text': _textController.text, // Hatırlatıcı metni.
                'time': _selectedTime!, // Seçilen zaman.
              });
            }
          },
          child: Text('Ekle'), // Buton metni.
        ),
      ],
    );
  }
}
