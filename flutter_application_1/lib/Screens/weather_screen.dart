// weather_screen.dart

import 'package:flutter/material.dart'; // Material tasarım bileşenleri ve widget'ları içerir.
import 'dart:convert'; // JSON verilerini çözümlemek için kullanılır.
import 'package:http/http.dart' as http; // HTTP isteklerini gerçekleştirmek için kullanılır.

// Hava durumu ekranını temsil eden StatefulWidget sınıfı.
class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState(); // State nesnesini oluşturur.
}

// Hava durumu ekranı için durum sınıfı.
class _WeatherScreenState extends State<WeatherScreen> {
  final TextEditingController _cityController = TextEditingController(); // Şehir adı girişi için bir kontrolcü.
  String? _weatherInfo; // Hava durumu bilgilerini tutar.
  bool isLoading = false; // Yükleniyor durumunu belirtir.

  // Hava durumu bilgisini getiren asenkron bir metot.
  Future<void> _fetchWeather() async {
    final city = _cityController.text; // Kullanıcının girdiği şehir adı.
    if (city.isNotEmpty) { // Eğer şehir adı boş değilse.
      setState(() {
        isLoading = true; // Yükleme durumunu başlatır.
      });

      final apiKey = '6a1b65798bc24090a1b114140251101'; // API anahtarı.
      final url =
          'https://api.weatherapi.com/v1/current.json?key=$apiKey&q=$city&aqi=no'; // Hava durumu API URL'si.

      try {
        final response = await http.get(Uri.parse(url)); // HTTP GET isteği gönderir.
        if (response.statusCode == 200) { // Eğer istek başarılıysa.
          final data = json.decode(response.body); // Gelen veriyi JSON olarak çözümler.
          setState(() {
            _weatherInfo =
                '${data["location"]["name"]}, ${data["location"]["country"]}: ' // Konum bilgisi.
                '${data["current"]["temp_c"]}°C, ${data["current"]["condition"]["text"]}'; // Sıcaklık ve hava durumu bilgisi.
          });
        } else { // Eğer şehir bulunamazsa.
          setState(() {
            _weatherInfo = 'Şehir bulunamadı.'; // Hata mesajı.
          });
        }
      } catch (e) { // Eğer bir hata oluşursa.
        setState(() {
          _weatherInfo = 'Hata: $e'; // Hata mesajını ayarlar.
        });
      } finally {
        setState(() {
          isLoading = false; // Yükleme durumunu sonlandırır.
        });
      }
    }
  }

//Widget, Flutter'da kullanıcı arayüzünün yapı taşı olup, görsel elemanlar (buton, metin, resim) veya davranışsal yapılar (düzenleme, kaydırma) gibi her şeyi temsil eder.
  @override
  Widget build(BuildContext context) {
    return Scaffold( // Ekranın temel düzen yapısını oluşturur.
      appBar: AppBar( // Üst kısımdaki uygulama çubuğu.
        title: Text('Hava Durumu'), // Uygulama çubuğunun başlığı.
      ),
      body: Padding( // İçeriğe kenar boşlukları ekler.
        padding: EdgeInsets.all(16.0), // Kenar boşluğu miktarı.
        child: Column( // Hava durumu bilgilerini ve giriş alanını içeren bir sütun.
          children: [
            TextField( // Şehir adı girişi için kullanılan bir metin alanı.
              controller: _cityController, // Kullanıcının girdiğini kontrol eden kontrolcü.
              decoration: InputDecoration(
                labelText: 'Şehir Adı', // Giriş alanı etiketi.
                border: OutlineInputBorder(), // Kenarlıklı bir giriş alanı.
              ),
            ),
            SizedBox(height: 10), // Giriş alanı ve buton arasına boşluk ekler.
            ElevatedButton( // Hava durumu bilgisini almak için kullanılan bir buton.
              onPressed: _fetchWeather, // Tıklandığında _fetchWeather metodu çağrılır.
              child: Text('Hava Durumunu Getir'), // Buton üzerindeki metin.
            ),
            SizedBox(height: 20), // Buton ve sonuç arasına boşluk ekler.
            isLoading // Eğer yükleme durumu aktifse.
                ? CircularProgressIndicator() // Yükleme göstergesi.
                : _weatherInfo != null // Eğer hava durumu bilgisi varsa.
                    ? Text(
                        _weatherInfo!, // Hava durumu bilgisi.
                        style: TextStyle(fontSize: 18), // Yazı boyutu ayarı.
                      )
                    : Container(), // Eğer bilgi yoksa boş bir alan.
          ],
        ),
      ),
    );
  }
}
