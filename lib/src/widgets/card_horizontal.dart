import 'package:flutter/material.dart';
import 'package:nextmovie/src/censured/censured.dart';
import 'package:nextmovie/src/models/pelicula_model.dart';

class CardHorizontal extends StatelessWidget {
  final List<Pelicula> peliculas;
  final Function nextPagina;
  final String name;

  final _pageController = new PageController(
    initialPage: 1,
    viewportFraction: 0.32,
  );

  //Constructor
  CardHorizontal(
      {@required this.peliculas,
      @required this.nextPagina,
      @required this.name});

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;
    // Disparar el eveto al llegar al final
    _pageController.addListener(() {
      if (_pageController.position.pixels >=
          _pageController.position.maxScrollExtent - 200) {
        nextPagina();
      }
    });

    return Container(
      height: _screenSize.height * 0.3,
      child: PageView.builder(
        pageSnapping: false,
        controller: _pageController,
        itemCount: censuradoPeliculas(),
        itemBuilder: (context, index) {
          return _tarjeta(context, peliculas[index]);
        },
      ),
    );
  }

  Widget _tarjeta(BuildContext context, Pelicula pelicula) {
    //Guardamos toda la configuracion de la tarjeta

    pelicula.uniqueId = '${pelicula.id}-$name';

    final tarjeta = Container(
      margin: EdgeInsets.only(right: 6.0),
      child: Column(
        children: <Widget>[
          Hero(
            tag: pelicula.uniqueId,
            child: ClipRRect(
              child: FadeInImage(
                image: NetworkImage(pelicula.getPosterImg()),
                placeholder: AssetImage('assets/img/loading.gif'),
                fit: BoxFit.cover,
                height: 180.0,
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          SizedBox(height: 5.0),
          Text(
            pelicula.title,
            style: Theme.of(context).textTheme.caption,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );

    // Identificar cuando sucede una accion en el elemento
    return GestureDetector(
      onTap: () {
        // Enviar datos desde esta pantalla detalle (arguments)
        Navigator.pushNamed(
          context,
          'detalle',
          arguments: pelicula,
        );
      },
      child: tarjeta,
    );
  }

  censuradoPeliculas<int>() {
    for (var i = 0; i < peliculas.length; i++) {
      for (var word in wordsCensured) {
        if (word == peliculas[i].title) {
          peliculas.remove(peliculas[i]);
        }
      }

      if (peliculas[i].originalLanguage == 'ja' ||
          peliculas[i].originalLanguage == 'zh') {
        peliculas.remove(peliculas[i]);
      }
    }
    return peliculas.length;
  }
}
