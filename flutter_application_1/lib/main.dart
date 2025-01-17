// main.dart

import 'package:flutter/material.dart'; // Material tasarım bileşenleri ve widget'ları içerir.
import 'package:provider/provider.dart'; // State yönetimi için Provider kütüphanesini kullanır.
import 'screens/home_screen.dart'; // Ana ekran için oluşturulan HomeScreen widget'ını içe aktarır.
import 'app_state.dart'; // Uygulama durumunu (state) yönetecek AppState sınıfını içe aktarır.

void main() {
  runApp(
    ChangeNotifierProvider(
      // AppState sınıfını sağlayan bir ChangeNotifierProvider ile uygulamayı başlatır.
      create: (_) => AppState(), // AppState'in bir örneğini oluşturur ve sağlar.
      child: MyApp(), // MyApp widget'ını kök widget olarak atar.
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      // AppState'teki değişiklikleri dinleyen bir Consumer widget'ı oluşturur.
      builder: (context, appState, child) {
        return MaterialApp(
          // Flutter uygulamasının temel yapı taşı olan MaterialApp widget'ını tanımlar.
          debugShowCheckedModeBanner: false, // Debug modu göstergesini devre dışı bırakır.
          title: 'Kişisel Asistan', // Uygulamanın başlığı.
          theme: ThemeData.light(), // Açık tema yapılandırması.
          darkTheme: ThemeData.dark(), // Karanlık tema yapılandırması.
          themeMode: appState.themeMode, // Tema modunu AppState'e göre belirler.
          home: HomeScreen(), // Ana ekran olarak HomeScreen widget'ını atar.
        );
      },
    );
  }
}