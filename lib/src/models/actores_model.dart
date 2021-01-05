class Cast {
  List<Actor> actores = new List();

  Cast.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) return;

    jsonList.forEach((item) {
      final actor = Actor.fromJsonMap(item);
      actores.add(actor);
    });
  }
}

class Actor {
  bool adult;
  int gender;
  int id;
  int order;
  int castId;
  double popularity;
  String knownForDepartment;
  String name;
  String character;
  String originalName;
  String profilePath;
  String creditId;
  String department;
  String job;

  Actor({
    this.adult,
    this.gender,
    this.id,
    this.knownForDepartment,
    this.name,
    this.originalName,
    this.popularity,
    this.profilePath,
    this.order,
    this.creditId,
    this.department,
    this.job,
    this.castId,
    this.character,
  });

  Actor.fromJsonMap(Map<String, dynamic> json) {
    adult = json['adult'];
    gender = json['gender'];
    id = json['id'];
    character = json['character'];
    order = json['order'];
    knownForDepartment = json['known_for_department'];
    name = json['name'];
    originalName = json['original_name'];
    popularity = json['popularity'];
    profilePath = json['profile_path'];
    creditId = json['credit_id'];
    department = json['department'];
    job = json['job'];
    castId = json['cast_id'];
  }

  getActorFoto() {
    if (profilePath == null) {
      return 'https://www.slotcharter.net/wp-content/uploads/2020/02/no-avatar.png';
    } else {
      return 'https://image.tmdb.org/t/p/w500$profilePath';
    }
  }
}
