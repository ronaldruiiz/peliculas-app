import 'package:flutter/material.dart';
import 'package:peliculas_app/models/pelicula_model.dart';
import 'package:peliculas_app/providers/peliculas_provider.dart';
import 'package:peliculas_app/search/search_delegate.dart';
import 'package:peliculas_app/widgets/card_swiper_widget.dart';
import 'package:peliculas_app/widgets/movie_horizontal.dart';

class HomePage extends StatelessWidget {
	static const namePage = '/';
	final peliculasProvider = PeliculasProvider();

	@override
	Widget build(BuildContext context) {
		peliculasProvider.getPopular();
		return Scaffold(
			appBar: AppBar(
				title: Text('Peliculas'),
				backgroundColor: Colors.indigoAccent,
				actions: <Widget>[
					IconButton(
						icon: Icon(Icons.search),
						onPressed: () {
							showSearch(context: context, delegate: DataSearch());
						},
					),
				],
			),
			body: Container(
				child: Column(
					mainAxisAlignment: MainAxisAlignment.spaceAround,
					children: <Widget>[
						_swiperTarjetas(),
						_footer(context)
					],
				),
			));
	}

	_swiperTarjetas() {
		return FutureBuilder(
			future: peliculasProvider.getEnCines(),
			builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
				final _screenSize = MediaQuery
					.of(context)
					.size;
				if (snapshot.hasData) {
					return CardSwiper(
						peliculas: snapshot.data,
					);
				} else {
					return Container(
						child: Center(
							child: CircularProgressIndicator(),
						));
				}
			},
		);
	}

	Widget _footer(BuildContext context) {
		return Container(
			width: double.infinity,
			child: Column(
				crossAxisAlignment: CrossAxisAlignment.start,
				children: <Widget>[
					Container(
						padding: EdgeInsets.only(left: 20),
						child: Text('Populares', style: Theme
							.of(context)
							.textTheme
							.subhead)
					),
					SizedBox(
						height: 5.0,
					),
					StreamBuilder(
						stream: peliculasProvider.popularesStream,
						builder: (BuildContext context,
							AsyncSnapshot<List<Pelicula>> snapshot) {

							if (snapshot.hasData) {
								return MovieHorizontal(
									peliculas: snapshot.data,
									siguientePagina: peliculasProvider
										.getPopular,
								);
							}
							else {
								return Center(
									child: Center(
										child: CircularProgressIndicator(),
									));
							}
						},
					)
				],
			),
		);
	}
}
