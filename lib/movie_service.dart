import 'package:dio/dio.dart';
import 'package:fakeflix/movie.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';



class MovieService {

  final dio = Dio();
  final String baseUrl = dotenv.env['TMDB_API'] ?? '';

  MovieService() {
    dio.options.queryParameters['api_key'] = dotenv.env['API_KEY'];
  }

  Future<List<Movie>> discoverMovie() async {
    Response response;
    response = await dio.get('${baseUrl}discover/movie');
    List<Movie> movies = (response.data['results'] as List)
        .map((json) => Movie.fromJson(json))
        .toList();
    return movies;
  }

  Future<Movie> getMovieById(int id) async {
    Response response;
    response = await dio.get('${baseUrl}movie/$id');
    Movie movie = Movie.fromJson(response.data);
    return movie;
  }
}