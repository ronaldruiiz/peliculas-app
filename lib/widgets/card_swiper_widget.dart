import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:peliculas_app/models/pelicula_model.dart';

class CardSwiper extends StatelessWidget {
  final List<Pelicula> peliculas;

  CardSwiper({@required this.peliculas});

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.only(top: 10.0),
      child: Swiper(
        itemWidth: _screenSize.width * 0.7,
        itemHeight: _screenSize.height * 0.5,
        itemBuilder: (BuildContext context, int index) {
          peliculas[index].uniqueId = '${ peliculas[index].id }-swipper';
          return  GestureDetector(
            onTap: (){
              timeDilation = 2;
              Navigator.pushNamed(context,'/detalle', arguments: this.peliculas[index]);
            },
            child: Hero(
              tag: peliculas[index].uniqueId,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child:  FadeInImage(
                  fit: BoxFit.cover,
                    placeholder: AssetImage('assets/img/no-image.jpg') ,
                    image: NetworkImage(peliculas[index].getPosterImg())),
              ),
            ),
          );
        },
        itemCount: peliculas.length,
        layout: SwiperLayout.STACK,
        //pagination: new SwiperPagination(),
        //control: new SwiperControl(),
      ),
    );
  }
}
