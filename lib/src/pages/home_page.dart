import 'package:flutter/material.dart';
import 'package:nextmovie/src/providers/pelicula_provider.dart';
import 'package:nextmovie/src/widgets/card_horizontal.dart';
import 'package:nextmovie/src/widgets/card_swiper_widget.dart';

class HomePage extends StatelessWidget {
  final peliculasProvider = new PeliculasProvider();

  @override
  Widget build(BuildContext context) {
    //inicializar nuestro provider
    peliculasProvider.getMoviePopulares();

    return Scaffold(
      appBar: AppBar(
        title: Text('Movies'),
        backgroundColor: Colors.indigoAccent,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            SizedBox(height: 30.0),
            _swiperTarjetas(),
            SizedBox(height: 60.0),
            _footer(context),
          ],
        ),
      ),
    );
  }

  //  Movies populares
  Widget _footer(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 10.0),
            child: Text(
              'Peliculas Populares',
              style: Theme.of(context).textTheme.subtitle2,
              textScaleFactor: 1.4,
            ),
          ),
          SizedBox(height: 10.0),
          StreamBuilder(
            stream: peliculasProvider.popularesStream,
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.hasData) {
                return CardHorizontal(
                  peliculas: snapshot.data,
                  nextPagina: peliculasProvider.getMoviePopulares,
                );
              } else
                return Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
            },
          ),
        ],
      ),
      width: double.infinity,
    );
  }

  // Widget last movies
  Widget _swiperTarjetas() {
    // Inicializar el servicio de get api
    return FutureBuilder(
      future: peliculasProvider.getOnCines(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return CardSwiper(
            peliculas: snapshot.data,
          );
        } else {
          return Container(
            height: 400.0,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
