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
  int _estrenosPage = 0;

  //para controlar las acciones que se dispara para la siguiente pagina
  bool _cargandoPopulares = false;
  bool _cargandoEstrenos = false;

// --- MANEJO PATRON BLOC MEDIANTE STREAM -----------------------
//--- Creacion de nuestras listas y tipo

  // ignore: deprecated_member_use
  List<Pelicula> _populares = new List();
  // ignore: deprecated_member_use
  List<Pelicula> _estrenos = new List();

// ----- Creacion de nuestros controlladores broadcast ----------
  final _popularesStreamController =
      StreamController<List<Pelicula>>.broadcast();

  final _estrenosStreamController =
      StreamController<List<Pelicula>>.broadcast();

// ----- insertando la data ala tuberia StreamController ---------
  Function(List<Pelicula>) get popularesSink =>
      _popularesStreamController.sink.add;

  Function(List<Pelicula>) get estrenosSink =>
      _estrenosStreamController.sink.add;

// -------- Escuchar la data de la salida de la tuberia StreamController ------
  Stream<List<Pelicula>> get popularesStream =>
      _popularesStreamController.stream;

  Stream<List<Pelicula>> get estrenosStream => _estrenosStreamController.stream;

// ------ Cerrando nuestras tuberias creadas -----------------
  void disposeStreams() {
    _popularesStreamController.close();
    _estrenosStreamController.close();
  }

// ------------------------- PETICIONES HTTP ASYNC - AWAIT --------------------

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
        '/3/movie/upcoming' +
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
    if (_cargandoPopulares) return [];

    _cargandoPopulares = true;
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

    _cargandoPopulares = false;

    return resp;
  }

// Obtener las peliculas en estreno
  Future<List<Pelicula>> getMovieEstreno() async {
    // una peticion por vez
    if (_cargandoEstrenos) return [];

    _cargandoEstrenos = true;
    _estrenosPage++;

    String url = _url +
        '/3/movie/upcoming' +
        '?api_key=' +
        _apikey +
        '&language=' +
        _language +
        '&page=' +
        _estrenosPage.toString();

    //optimizado
    final resp = await _procesarRespuesta(url);

    // agregando la info al stream
    _estrenos.addAll(resp);
    estrenosSink(_estrenos);
    // --------------------

    _cargandoEstrenos = false;

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

  // Finder Trailer en español  -> sino idioma original
  Future<List<Trailer>> getTrailer(String pelId, String idioma) async {
    String url = _url +
        '/3/movie/$pelId/videos' +
        '?api_key=' +
        _apikey +
        '&language=' +
        'es';
    final res = await http.get(url);
    final decodedDate = json.decode(res.body);
    final peliTrailer = new Trailers.fromJsonList(decodedDate['results']);

    if (peliTrailer.trailers.length == 0) {
      return _changeLanguage(peliTrailer.trailers, idioma, pelId);
    } else {
      return peliTrailer.trailers;
    }
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

  // Cambio de lenguaje trailer a ORIGINAL
  Future<List<Trailer>> _changeLanguage(
      List<Trailer> peliculaTrailer, String idioma, String pelId) async {
    String url = _url +
        '/3/movie/$pelId/videos' +
        '?api_key=' +
        _apikey +
        '&language=' +
        '$idioma';
    final res = await http.get(url);
    final decodedDate = json.decode(res.body);
    final trailerOriginal = new Trailers.fromJsonList(decodedDate['results']);

    return trailerOriginal.trailers.length == 0
        ? null
        : trailerOriginal.trailers;
  }
}
