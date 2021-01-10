import 'package:firebase_admob/firebase_admob.dart';

import 'package:flutter/material.dart';
import 'package:nextmovie/src/models/actores_model.dart';
import 'package:nextmovie/src/models/pelicula_model.dart';
import 'package:nextmovie/src/models/trailer_model.dart';
import 'package:nextmovie/src/providers/pelicula_provider.dart';
import 'package:nextmovie/src/widgets/video_youtube_widget.dart';

class PeliculaDetallePage extends StatefulWidget {
  @override
  _PeliculaDetallePageState createState() => _PeliculaDetallePageState();
}

class _PeliculaDetallePageState extends State<PeliculaDetallePage> {
  /* --- admob --- */
  BannerAd myBannerAd;

  BannerAd buildBannerAd() {
    return BannerAd(
        adUnitId: BannerAd.testAdUnitId,
        size: AdSize.banner,
        listener: (MobileAdEvent event) {
          if (event == MobileAdEvent.loaded) {
            myBannerAd..show();
          }
        });
  }

  @override
  void initState() {
    super.initState();
    myBannerAd = buildBannerAd()..load();
  }

  @override
  void dispose() {
    myBannerAd.dispose();
    super.dispose();
  }

  /// --- admob end -----
  @override
  Widget build(BuildContext context) {
    // recibir datos enviados de otra pantalla
    final Pelicula pelicula = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          _crearAppbar(pelicula),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                SizedBox(height: 20.0),
                _posterTitulo(context, pelicula),
                _descripcion(context, pelicula),
                _crearCasting(pelicula),
                SizedBox(height: 20.0),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _crearAppbar(Pelicula pelicula) {
    final peliProvider = new PeliculasProvider();
    return SliverAppBar(
      elevation: 2.0,
      backgroundColor: Colors.red[600],
      expandedHeight: 200.0,
      pinned: true,
      floating: false,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        /* title: Text(
                          pelicula.title,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            shadows: [
                              Shadow(
                                blurRadius: 10.0,
                                color: Colors.black38,
                                offset: Offset(1.0, 1.0),
                              ),
                            ],
                            color: Colors.white,
                          ),
                        ), */
        background: FutureBuilder(
          future: peliProvider.getTrailer(
            pelicula.id.toString(),
            pelicula.originalLanguage,
          ),
          builder: (context, AsyncSnapshot<List> snapshot) {
            if (snapshot.hasData) {
              Trailer trailer;
              for (int index = 0; index < snapshot.data.length; index++) {
                trailer = snapshot.data[index];
              }
              return YoutubePlayerWidget(trailer.getKeyForVideo());
            } else {
              return FadeInImage(
                image: NetworkImage(pelicula.getBackgroundImg()),
                placeholder: AssetImage('assets/img/loading.gif'),
                fadeInDuration: Duration(milliseconds: 150),
                fit: BoxFit.cover,
              );
            }
          },
        ),
        /* FadeInImage(
                          image: NetworkImage(pelicula.getBackgroundImg()),
                          placeholder: AssetImage('assets/img/loading.gif'),
                          fadeInDuration: Duration(milliseconds: 150),
                          fit: BoxFit.cover,
                        ), */
      ),
    );
  }

  Widget _posterTitulo(BuildContext context, Pelicula pelicula) {
    final poster = Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: <Widget>[
          Hero(
            tag: pelicula.uniqueId,
            child: ClipRRect(
              child: Image(
                image: NetworkImage(pelicula.getPosterImg()),
                height: 150.0,
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          SizedBox(width: 20.0),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  pelicula.title,
                  style: Theme.of(context).textTheme.subtitle2,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(pelicula.originalTitle,
                    style: Theme.of(context).textTheme.caption,
                    overflow: TextOverflow.ellipsis),
                SizedBox(height: 10.0),
                Row(
                  children: [
                    Icon(Icons.star_border),
                    Text(pelicula.voteAverage.toString()),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );

    // cliquear sobre la imagen
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: poster,
    );
  }

  Widget _descripcion(BuildContext context, Pelicula pelicula) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
      child: Text(
        _validacionDescripcion(pelicula),
        style: Theme.of(context).textTheme.bodyText2,
        textAlign: TextAlign.justify,
      ),
    );
  }

  _validacionDescripcion(Pelicula pelicula) {
    if (pelicula.overview.length == 0 || pelicula.overview == null) {
      return 'En el momento no tenemos una descripcion de esta pelicula...';
    } else {
      return pelicula.overview;
    }
  }

  Widget _crearCasting(Pelicula pelicula) {
    final peliProvider = new PeliculasProvider();

    return FutureBuilder(
      future: peliProvider.getCast(pelicula.id.toString()),
      builder: (context, AsyncSnapshot<List> snapshot) {
        if (snapshot.hasData) {
          return _crearActoresPageView(snapshot.data);
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _crearActoresPageView(List<Actor> actores) {
    return SizedBox(
      height: 200.0,
      child: PageView.builder(
        pageSnapping: false,
        scrollDirection: Axis.horizontal,
        controller: PageController(
          viewportFraction: 0.3,
          initialPage: 1,
        ),
        itemCount: actores.length,
        itemBuilder: (context, i) {
          return _actorTarjeta(context, actores[i]);
        },
      ),
    );
  }

  Widget _actorTarjeta(BuildContext context, Actor actor) {
    return Container(
      margin: EdgeInsets.only(right: 6.0),
      child: Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: FadeInImage(
              fadeInCurve: Curves.bounceInOut,
              image: NetworkImage(actor.getActorFoto()),
              placeholder: AssetImage('assets/img/loading.gif'),
              height: 150.0,
              fit: BoxFit.cover,
            ),
          ),
          Text(
            actor.name,
            style: Theme.of(context).textTheme.caption,
          ),
        ],
      ),
    );
  }
}
