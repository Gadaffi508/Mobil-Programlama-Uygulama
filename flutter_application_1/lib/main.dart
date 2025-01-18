// main.dart

import 'package:flutter/material.dart'; // Material tasarım bileşenleri ve widget'ları içerir.
import 'package:provider/provider.dart'; // State yönetimi için Provider kütüphanesini kullanır.
import 'screens/home_screen.dart'; // Ana ekran için oluşturulan HomeScreen widget'ını içe aktarır.
import 'app_state.dart'; // Uygulama durumunu (state) yönetecek AppState sınıfını içe aktarır.

void main() {
  runApp( // uygulama çalıştır.
    ChangeNotifierProvider( // durum değişikliklerini dinleyen widgetların otomatik olarak yeniden oluşturulmasını sağlayarak manuel kontrol ihtiyacını ortadan kaldırır.
      // AppState sınıfını sağlayan bir ChangeNotifierProvider ile uygulamayı başlatır.
      create: (_) => AppState(), // AppState'in bir örneğini oluşturur ve sağlar.
      child: MyApp(), // MyApp widget'ını kök widget olarak atar.
    ),
  );
}

class MyApp extends StatelessWidget { //StatelessWidget yalnızca statik ve değişmeyen kullanıcı arayüzlerini tanımlamak için kullanılan bir Flutter widget sınıfıdır.
  @override
  //Widget, Flutter'da kullanıcı arayüzünün yapı taşı olup, görsel elemanlar (buton, metin, resim) veya davranışsal yapılar (düzenleme, kaydırma) gibi her şeyi temsil eder.
  Widget build(BuildContext context) { // metodu, bir widget'ın kullanıcı arayüzünü oluşturur ve widget ağacında konumlandığı yeri belirlemek için BuildContext sağlar.
    return Consumer<AppState>(
      // AppState'teki değişiklikleri dinleyen bir Consumer widget'ı oluşturur.
      builder: (context, appState, child) { //  ifadesi, Consumer widget'ının yeniden oluşturulacak kısmını tanımlayarak context, durum (appState), 
      //ve isteğe bağlı olarak değişmeyen bir alt widget (child) sağlar.
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