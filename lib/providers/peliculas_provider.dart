import 'dart:async';
import 'dart:convert';

import 'package:peliculas_app/models/pelicula_model.dart';
import 'package:http/http.dart' as http;
import '../models/actor_model.dart';

class PeliculasProvider {
	String _apikey = 'd2b8c392c4ab613c9978e3aedd112da9';
	String _url = 'api.themoviedb.org';
	String _languaje = 'es-ES';

	int _popularesPage = 0;
	bool _cargando = false;

	List<Pelicula> _populares = new List();

	final _popularesStreamController = StreamController<List<Pelicula>>.broadcast();

	 Function(List<Pelicula>) get popularesSink => _popularesStreamController.sink.add;

	 Stream<List<Pelicula>> get popularesStream => _popularesStreamController.stream;

	void disposeStreams(){
		_popularesStreamController?.close();
	}

	Future<List<Pelicula>> _processResult(Uri uri) async {
		final response = await http.get(uri);
		final decodedData = json.decode(response.body);

		final peliculas = Peliculas.fromJsonList(decodedData['results']);

		return peliculas.items;
	}

	Future<List<Pelicula>> getEnCines() async {
		final url = Uri.https(_url, '3/movie/now_playing',
			{'api_key': _apikey, 'languaje': _languaje});

		return await _processResult(url);
	}

	Future<List<Pelicula>> buscarPeliculas(String query) async {
		final url = Uri.https(_url, '3/search/movie',
			{'api_key': _apikey, 'languaje': _languaje,'query':query}
			);

		return await _processResult(url);
	}

	Future<List<Pelicula>> getPopular() async {
		if(_cargando) return [];

		_cargando = true;
		_popularesPage++;

		final url = Uri.https(
			_url, '3/movie/popular',
			{
				'api_key': _apikey,
				'languaje': _languaje,
				'page':_popularesPage.toString()
			});

		final resp = await _processResult(url);

		_populares.addAll(resp);
		
		popularesSink(_populares);

		_cargando = false;
		return resp;
	}
	
	Future<List<Actor>> getCast(String movieId) async{
		final url = Uri.https(_url,'3/movie/$movieId/credits',{
			'api_key': _apikey, 'languaje': _languaje
		});

		final resp = await http.get(url);
		final decodedData = json.decode(resp.body);

		final cast = new Cast.fromJsonList(decodedData['cast']);
		return cast.actores;
	}
}
