import 'package:flutter/material.dart';
import 'package:nextmovie/src/pages/home_page.dart';
import 'package:nextmovie/src/pages/pelicula_detalle.dart';
import 'package:nextmovie/src/pages/splash_screen.dart';
import 'package:nextmovie/src/providers/conex_provider.dart';

void main() async {
  //Conexion de datos
  WidgetsFlutterBinding.ensureInitialized();
  ConnectionStatusSingleton connectionStatus =
      ConnectionStatusSingleton.getInstance();
  connectionStatus.initialize();

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
