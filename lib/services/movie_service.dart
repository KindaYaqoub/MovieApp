import 'package:dio/dio.dart';
import '../models/movie_model.dart';

class MovieService {
  final Dio dio = Dio();



  final String apiKey = "PUT_API_KEY_HERE";

  Future<List<Movie>> searchMovies(String query) async {
    final response = await dio.get(
      "https://api.themoviedb.org/3/search/movie",
      queryParameters: {
        "api_key": apiKey,
        "query": query,
      },
    );

    final results = response.data["results"] as List;

    return results.map((movie) => Movie.fromJson(movie)).toList();
  }
}