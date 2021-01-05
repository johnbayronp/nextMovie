import 'dart:async';
import 'dart:convert';

import 'package:nextmovie/src/models/actores_model.dart';
import 'package:nextmovie/src/models/pelicula_model.dart';

// Importar desde pub.dev - http
import 'package:http/http.dart' as http;
import 'package:nextmovie/src/models/trailer_model.dart';

class PeliculasProvider {
  String _url = 'https://api.themoviedb.org';
  String _apikey = '0ef9792d58851e36ea015db03f6ec76c';
  String _language = 'es-MX';

  int _popularesPage = 0;

  //para controlar las acciones que se dispara para la siguiente pagina
  bool _cargando = false;

  // Manejo del stream para el patron bloc ----------------------- ---
  List<Pelicula> _populares = new List();
  final _popularesStreamController =
      StreamController<List<Pelicula>>.broadcast();

  // insertando la data ala tuberia StreamController
  Function(List<Pelicula>) get popularesSink =>
      _popularesStreamController.sink.add;

  // Escuchar la data de la salida de la tuberia
  Stream<List<Pelicula>> get popularesStream =>
      _popularesStreamController.stream;

  // metodo para cerrar los streams
  void disposeStreams() {
    _popularesStreamController.close();
  }

  // Procesar la respuesta
  Future<List<Pelicula>> _procesarRespuesta(String url) async {
    final resp = await http.get(url);
    final decodedDate = json.decode(resp.body);
    final peliculas = new Peliculas.fromJsonList(decodedDate['results']);
    return peliculas.items;
  }

  // Obtener las peliculas nuevas
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

  // Obtener las peliculas populares
  Future<List<Pelicula>> getMoviePopulares() async {
    // una peticion por vez
    if (_cargando) return [];

    _cargando = true;
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

    _cargando = false;

    return resp;
  }

  // Obtener los actores
  Future<List<Actor>> getCast(String peliId) async {
    String url = _url +
        '/3/movie/$peliId/credits' +
        '?api_key=' +
        _apikey +
        '&language=' +
        _language;

    final res = await http.get(url);
    final decodedDate = json.decode(res.body);
    final cast = new Cast.fromJsonList(decodedDate['cast']);

    return cast.actores;
  }

  // Finder Trailer
  Future<List<Trailer>> getTrailer(String pelId, String idioma) async {
    String url = _url +
        '/3/movie/$pelId/videos' +
        '?api_key=' +
        _apikey +
        '&language=' +
        '$idioma';
    final res = await http.get(url);
    final decodedDate = json.decode(res.body);
    final peliTrailer = new Trailers.fromJsonList(decodedDate['results']);

    return peliTrailer.trailers;
  }

  // Finder of peliculas
  Future<List<Pelicula>> buscarPelicula(String query) async {
    String url = _url +
        '/3/search/movie' +
        '?api_key=' +
        _apikey +
        '&language=' +
        _language +
        '&query=' +
        query;

    final res = await _procesarRespuesta(url);
    return res;
  }
}
