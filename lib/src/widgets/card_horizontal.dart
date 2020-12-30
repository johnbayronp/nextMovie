import 'package:flutter/material.dart';
import 'package:nextmovie/src/models/pelicula_model.dart';

class CardHorizontal extends StatelessWidget {
  final List<Pelicula> peliculas;
  final Function nextPagina;

  final _pageController = new PageController(
    initialPage: 1,
    viewportFraction: 0.32,
  );

  //Constructor
  CardHorizontal({@required this.peliculas, @required this.nextPagina});

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
      child: PageView(
        pageSnapping: false,
        controller: _pageController,
        children: _tarjetas(context),
      ),
    );
  }

  List<Widget> _tarjetas(BuildContext context) {
    return peliculas.map((pelicula) {
      return Container(
        margin: EdgeInsets.only(right: 6.0),
        child: Column(
          children: <Widget>[
            ClipRRect(
              child: FadeInImage(
                image: NetworkImage(pelicula.getPosterImg()),
                placeholder: AssetImage('assets/img/loading.gif'),
                fit: BoxFit.cover,
                height: 180.0,
              ),
              borderRadius: BorderRadius.circular(10.0),
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
    }).toList();
  }
}
