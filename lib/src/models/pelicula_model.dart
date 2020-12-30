class Peliculas {
  // Lista de items de peliculas
  List<Pelicula> items = new List();
  //Constructor
  Peliculas();

  //constructor para recibir una lista de datos de pelicula tipo json
  Peliculas.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) {
      return;
    }

    for (var item in jsonList) {
      final pelicula = new Pelicula.fromJsonMap(item);
      items.add(pelicula);
    }
  }
}

// correr en ctrl+shif+p -> paste json of code -> Respuesta
class Pelicula {
  bool adult;
  String backdropPath;
  List<int> genreIds;
  int id;
  String originalLanguage;
  String originalTitle;
  String overview;
  double popularity;
  String posterPath;
  String releaseDate;
  String title;
  bool video;
  double voteAverage;
  int voteCount;

  Pelicula({
    this.adult,
    this.backdropPath,
    this.genreIds,
    this.id,
    this.originalLanguage,
    this.originalTitle,
    this.overview,
    this.popularity,
    this.posterPath,
    this.releaseDate,
    this.title,
    this.video,
    this.voteAverage,
    this.voteCount,
  });

  Pelicula.fromJsonMap(Map<String, dynamic> json) {
    id = json['id'];
    originalLanguage = json['original_language'];
    originalTitle = json['original_title'];
    backdropPath = json['backdrop_path'];
    adult = json['adult'];
    overview = json['overview'];
    popularity = json['popularity'] / 1;
    releaseDate = json['release_date'];
    title = json['title'];
    video = json['video'];
    voteAverage = json['vote_average'] / 1;
    voteCount = json['vote_count'];
    genreIds = json['genre_ids'].cast<int>();
    posterPath = json['poster_path'];
  }

  getPosterImg() {
    if (posterPath == null) {
      return 'https://i.pinimg.com/originals/88/f6/c1/88f6c14d05f2972452f424560f8a8ca3.png';
    } else {
      return 'https://image.tmdb.org/t/p/w500$posterPath';
    }
  }
}
