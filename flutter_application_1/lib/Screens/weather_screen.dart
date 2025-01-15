// weather_screen.dart
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final TextEditingController _cityController = TextEditingController();
  String? _weatherInfo;
  bool isLoading = false;

  Future<void> _fetchWeather() async {
    final city = _cityController.text;
    if (city.isNotEmpty) {
      setState(() {
        isLoading = true;
      });

      final apiKey = '6a1b65798bc24090a1b114140251101';
      final url =
          'https://api.weatherapi.com/v1/current.json?key=$apiKey&q=$city&aqi=no';

      try {
        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          setState(() {
            _weatherInfo =
                '${data["location"]["name"]}, ${data["location"]["country"]}: '
                '${data["current"]["temp_c"]}°C, ${data["current"]["condition"]["text"]}';
          });
        } else {
          setState(() {
            _weatherInfo = 'Şehir bulunamadı.';
          });
        }
      } catch (e) {
        setState(() {
          _weatherInfo = 'Hata: $e';
        });
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hava Durumu'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _cityController,
              decoration: InputDecoration(
                labelText: 'Şehir Adı',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _fetchWeather,
              child: Text('Hava Durumunu Getir'),
            ),
            SizedBox(height: 20),
            isLoading
                ? CircularProgressIndicator()
                : _weatherInfo != null
                    ? Text(
                        _weatherInfo!,
                        style: TextStyle(fontSize: 18),
                      )
                    : Container(),
          ],
        ),
      ),
    );
  }
}
