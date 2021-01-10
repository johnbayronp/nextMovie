class Trailers {
  // ignore: deprecated_member_use
  List<Trailer> trailers = new List();

  // Si tenemos una lista de trailers addicionarlos
  Trailers.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) return;

    jsonList.forEach((item) {
      final trailer = Trailer.fromJsonMap(item);
      trailers.add(trailer);
    });
  }
}

class Trailer {
  String id;
  String iso6391;
  String iso31661;
  String key;
  String name;
  String site;
  int size;
  String type;

  Trailer({
    this.id,
    this.iso6391,
    this.iso31661,
    this.key,
    this.name,
    this.site,
    this.size,
    this.type,
  });

  Trailer.fromJsonMap(Map<String, dynamic> json) {
    iso6391 = json['iso_639_1'];
    iso31661 = json['iso_3166_1'];
    key = json['key'];
    name = json['name'];
    site = json['site'];
    size = json['size'];
    type = json['type'];
    id = json['id'];
  }

  getKeyForVideo() {
    if (key == null) {
      print('null');
      return;
    } else {
      return '$key';
    }
  }
}
