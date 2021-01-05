import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:nextmovie/src/models/pelicula_model.dart';

class CardSwiper extends StatelessWidget {
  final List<Pelicula> peliculas;
  //requiere como parametros peliculas
  CardSwiper({@required this.peliculas});

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.only(top: 20.0),
      child: Swiper(
        layout: SwiperLayout.STACK,
        itemWidth: _screenSize.width * 0.6,
        itemHeight: _screenSize.height * 0.40,
        itemBuilder: (BuildContext context, int index) {
          peliculas[index].uniqueId = '${peliculas[index].id}-poster';

          return Hero(
            tag: peliculas[index].uniqueId,
            child: ClipRRect(
              child: GestureDetector(
                child: FadeInImage(
                  image: NetworkImage(peliculas[index].getPosterImg()),
                  placeholder: AssetImage('assets/img/loading.gif'),
                  fit: BoxFit.cover,
                ),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    'detalle',
                    arguments: peliculas[index],
                  );
                },
              ),
              borderRadius: BorderRadius.circular(20.0),
            ),
          );
        },
        itemCount: peliculas.length,
      ),
    );
  }
}
