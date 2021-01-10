import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nextmovie/src/providers/conex_provider.dart';
import 'package:nextmovie/src/providers/pelicula_provider.dart';
import 'package:nextmovie/src/widgets/card_horizontal.dart';
import 'package:nextmovie/src/widgets/card_swiper_widget.dart';

// importamos nuestro delegate de search
import 'package:nextmovie/src/search/search_delegate.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final peliculasProvider = new PeliculasProvider();

  StreamSubscription _connectionChangeStream;
  bool isOffline = false;

  @override
  void initState() {
    super.initState();
    ConnectionStatusSingleton connectionStatus =
        ConnectionStatusSingleton.getInstance();
    _connectionChangeStream =
        connectionStatus.getconnectionChange().listen(connectionChanged);
  }

  void connectionChanged(dynamic hasConnection) {
    setState(() {
      isOffline = !hasConnection;
    });

    peliculasProvider.getMoviePopulares();
    peliculasProvider.getMovieEstreno();
  }

  @override
  Widget build(BuildContext context) {
    //inicializar nuestro provider

    return Scaffold(
      appBar: AppBar(
        title: Text('Next Movie'),
        backgroundColor: Colors.red[600],
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: DataSearch(),
                //query
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          child: isOffline == true
              ? new Container(
                  child: _sinConexion(),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    SizedBox(height: 10.0),
                    _subtitle(context),
                    SizedBox(height: 1.0),
                    _swiperTarjetas(),
                    SizedBox(height: 20.0),
                    _populares(context),
                    SizedBox(height: 5.0),
                    _estrenos(context),
                    SizedBox(height: 5.0),
                  ],
                ),
        ),
      ),
      backgroundColor: isOffline == true ? Colors.white : null,
    );
  }

  Widget _sinConexion() {
    return Center(
      child: Container(
        child: Column(children: <Widget>[
          SizedBox(height: 100),
          Image.asset(
            'assets/img/nodat.gif',
            fit: BoxFit.contain,
          ),
          Text(
            'No hay Conexión a Internet',
            style: Theme.of(context).textTheme.caption,
            textScaleFactor: 1.65,
          ),
        ]),
      ),
    );
  }

  Widget _subtitle(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: 10.0),
          child: Text(
            'Proximos estrenos',
            style: Theme.of(context).textTheme.subtitle2,
            textScaleFactor: 1.4,
          ),
        ),
      ],
    );
  }

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

  Widget _populares(BuildContext context) {
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
                  name: 'populares',
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

  Widget _estrenos(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 10.0),
            child: Text(
              'Peliculas en Estreno',
              style: Theme.of(context).textTheme.subtitle2,
              textScaleFactor: 1.4,
            ),
          ),
          SizedBox(height: 10.0),
          StreamBuilder(
            stream: peliculasProvider.estrenosStream,
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.hasData) {
                return CardHorizontal(
                  peliculas: snapshot.data,
                  nextPagina: peliculasProvider.getMovieEstreno,
                  name: 'estrenos',
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
}
