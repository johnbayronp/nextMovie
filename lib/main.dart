import 'package:flutter/material.dart';
import 'package:nextmovie/src/pages/home_page.dart';
import 'package:nextmovie/src/pages/pelicula_detalle.dart';
import 'package:nextmovie/src/providers/conex_provider.dart';
//Ads
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() async {
  //Conexion de datos
  WidgetsFlutterBinding.ensureInitialized();
  ConnectionStatusSingleton connectionStatus =
      ConnectionStatusSingleton.getInstance();
  connectionStatus.initialize();

  // Inicializar admob
  MobileAds.instance.initialize();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Next Movie',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (BuildContext context) => HomePage(),
        /* 
        'splash': (BuildContext context) => SplashScreen(), */
        'detalle': (BuildContext context) => PeliculaDetallePage(),
      },
    );
  }
}
