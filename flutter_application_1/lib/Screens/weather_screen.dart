// weather_screen.dart

import 'package:flutter/material.dart'; // Material tasarım bileşenleri ve widget'ları içerir.
import 'dart:convert'; // JSON verilerini çözümlemek için kullanılır.
import 'package:http/http.dart' as http; // HTTP isteklerini gerçekleştirmek için kullanılır.

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState(); // State nesnesini oluşturur.
}

class _WeatherScreenState extends State<WeatherScreen> {
  final TextEditingController _cityController = TextEditingController(); // Şehir adı girişi için bir kontrolcü.
  String? _weatherInfo; // Hava durumu bilgilerini tutar.
  bool isLoading = false; // Yükleniyor durumunu belirtir.

  // Hava durumu bilgisini getiren asenkron bir metot.
  Future<void> _fetchWeather() async {
    final city = _cityController.text; // Kullanıcının girdiği şehir adı.
    if (city.isNotEmpty) {
      setState(() {
        isLoading = true; // Yükleme durumunu başlatır.
      });

      final apiKey = '6a1b65798bc24090a1b114140251101'; // API anahtarı.
      final url =
          'https://api.weatherapi.com/v1/current.json?key=$apiKey&q=$city&aqi=no'; // Hava durumu API URL'si.

      try {
        final response = await http.get(Uri.parse(url)); // HTTP GET isteği gönderir.
        if (response.statusCode == 200) {
          // Eğer istek başarılıysa.
          final data = json.decode(response.body); // Gelen veriyi JSON olarak çözümler.
          setState(() {
            _weatherInfo =
                '${data["location"]["name"]}, ${data["location"]["country"]}: ' // Konum bilgisi.
                '${data["current"]["temp_c"]}°C, ${data["current"]["condition"]["text"]}'; // Sıcaklık ve hava durumu.
          });
        } else {
          // Eğer şehir bulunamazsa.
          setState(() {
            _weatherInfo = 'Şehir bulunamadı.'; // Hata mesajı.
          });
        }
      } catch (e) {
        // Eğer bir hata oluşursa.
        setState(() {
          _weatherInfo = 'Hata: $e'; // Hata mesajı.
        });
      } finally {
        setState(() {
          isLoading = false; // Yükleme durumunu sonlandırır.
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Uygulamanın üst kısmındaki çubuk.
        title: Text('Hava Durumu'), // Çubuğun başlığı.
      ),
      body: Padding(
        // Kenar boşlukları ekler.
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              // Şehir adı girişi için bir metin alanı.
              controller: _cityController, // Giriş kontrolcüsü.
              decoration: InputDecoration(
                labelText: 'Şehir Adı', // Giriş alanı etiketi.
                border: OutlineInputBorder(), // Kenarlıklı giriş alanı.
              ),
            ),
            SizedBox(height: 10), // Giriş alanı ve buton arasına boşluk.
            ElevatedButton(
              // Hava durumu bilgisini almak için bir buton.
              onPressed: _fetchWeather, // Tıklandığında _fetchWeather metodu çağrılır.
              child: Text('Hava Durumunu Getir'), // Buton metni.
            ),
            SizedBox(height: 20), // Buton ve sonuç arasına boşluk.
            isLoading
                ? CircularProgressIndicator() // Eğer yükleniyorsa yükleme göstergesi.
                : _weatherInfo != null
                    ? Text(
                        _weatherInfo!, // Hava durumu bilgisi.
                        style: TextStyle(fontSize: 18), // Yazı boyutu.
                      )
                    : Container(), // Eğer bilgi yoksa boş alan.
          ],
        ),
      ),
    );
  }
}
