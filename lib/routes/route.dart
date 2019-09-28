import 'package:flutter/material.dart';
import 'package:peliculas_app/pages/home_page.dart';
import 'package:peliculas_app/pages/pelicula_detalle_page.dart';

final Map<String, WidgetBuilder> route = {
  HomePage.namePage:(BuildContext context)=>HomePage(),
  PeliculaDetallePage.namePage:(BuildContext context)=>PeliculaDetallePage(),
};