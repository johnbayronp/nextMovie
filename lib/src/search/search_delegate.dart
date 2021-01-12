import 'package:flutter/material.dart';
import 'package:nextmovie/src/censured/censured.dart';
import 'package:nextmovie/src/models/pelicula_model.dart';
import 'package:nextmovie/src/providers/pelicula_provider.dart';

class DataSearch extends SearchDelegate {
  String seleccion = '';

  final peliculasProvider = new PeliculasProvider();

  /* 
  final peliculas = ['superman', 'x-men', 'minions'];
  final peliculasRecientes = ['superman', 'x-men', 'SportMax']; */
  @override
  List<Widget> buildActions(BuildContext context) {
    // Acciones de nuestro appBar - [x] o cancela

    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          close(context, null);
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Icono ala izquierda del appBar

    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    /*  // Crea los resultados que vamos a mostrar
    return Center(
      child: Container(
        height: 100.0,
        width: 100.0,
        color: Colors.red,
        child: Text(seleccion),
      ),
    ); */
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Sugerencias que aparecen cuando la persona escribe

    if (query.isEmpty) {
      return Container();
    }

    return FutureBuilder(
      future: peliculasProvider.buscarPelicula(censuradoQuery(query)),
      builder: (BuildContext context, AsyncSnapshot<List<Pelicula>> snapshot) {
        if (snapshot.hasData) {
          final peliculas = snapshot.data;
          censuradoPeliculas(peliculas);

          return ListView(
              children: peliculas.map((pelicula) {
            return ListTile(
                leading: FadeInImage(
                  image: NetworkImage(pelicula.getPosterImg()),
                  placeholder: AssetImage('assets/img/noimage.jpg'),
                  fit: BoxFit.cover,
                  width: 50.0,
                ),
                title: Text(pelicula.title),
                subtitle: Text(pelicula.originalTitle),
                onTap: () {
                  pelicula.uniqueId = '';
                  Navigator.pushNamed(context, 'detalle', arguments: pelicula);
                });
          }).toList());
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );

    /* final listaSugerida = (query.isEmpty)
        ? peliculasRecientes
        : peliculas
            .where((p) => p.toLowerCase().startsWith(query.toLowerCase()))
            .toList();

    return ListView.builder(
      itemCount: listaSugerida.length,
      itemBuilder: (context, i) {
        return ListTile(
          leading: Icon(Icons.movie),
          title: Text(
            listaSugerida[i],
          ),
          onTap: () {
            seleccion = listaSugerida[i];
            //showResults(context);
          },
        );
      },
    ); */
  }

  void censuradoPeliculas(List<Pelicula> peliculas) {
    for (var i = 0; i < peliculas.length; i++) {
      // string.contains print(peliculas[i].title);
      if (peliculas[i].originalLanguage == 'ja' ||
          peliculas[i].originalLanguage == 'zh' ||
          peliculas[i].originalLanguage == 'fi' ||
          peliculas[i].originalLanguage == 'sv') {
        peliculas.remove(peliculas[i]);
      }
    }
  }

  censuradoQuery<String>(query) {
    for (var x = 0; x < wordsCensured.length; x++) {
      if (query.toUpperCase().contains(wordsCensured[x])) {
        return '231se24r';
      }
    }
    return query;
  }
}
