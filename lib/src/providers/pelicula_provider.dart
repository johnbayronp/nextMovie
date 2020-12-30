import 'dart:async';
import 'dart:convert';

import 'package:nextmovie/src/models/pelicula_model.dart';

// Importar desde pub.dev - http
import 'package:http/http.dart' as http;

class PeliculasProvider {
  String _url = 'https://api.themoviedb.org';
  String _apikey = '0ef9792d58851e36ea015db03f6ec76c';
  String _language = 'es-MX';

  int _popularesPage = 0;

  // Manejo del stream para el patron bloc --------------------------
  List<Pelicula> _populares = new List();
  final _popularesStreamController =
      StreamController<List<Pelicula>>.broadcast();

  // insertando la data ala tuberia StreamController
  Function(List<Pelicula>) get popularesSink =>
      _popularesStreamController.sink.add;

  // Escuchar la data de la salida de la tuberia
  Stream<List<Pelicula>> get popularesStream =>
      _popularesStreamController.stream;

  //metodo para cerrar los streams
  void disposeStreams() {
    _popularesStreamController.close();
  }

  Future<List<Pelicula>> _procesarRespuesta(String url) async {
    final resp = await http.get(url);
    final decodedDate = json.decode(resp.body);
    final peliculas = new Peliculas.fromJsonList(decodedDate['results']);
    return peliculas.items;
  }

  Future<List<Pelicula>> getOnCines() async {
    String url = _url +
        '/3/movie/now_playing' +
        '?api_key=' +
        _apikey +
        '&language=' +
        _language;

    //optimizado
    return await _procesarRespuesta(url);
  }

  Future<List<Pelicula>> getMoviePopulares() async {
    _popularesPage++;

    String url = _url +
        '/3/movie/popular' +
        '?api_key=' +
        _apikey +
        '&language=' +
        _language +
        '&page=' +
        _popularesPage.toString();

    //optimizado
    final resp = await _procesarRespuesta(url);

    // agregando la info al stream
    _populares.addAll(resp);
    popularesSink(_populares);
    // --------------------

    return resp;
  }
}
