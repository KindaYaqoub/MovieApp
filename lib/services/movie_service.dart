import 'package:dio/dio.dart';
import '../models/movie_model.dart';

class MovieService {
  static const String _apiKey = '67a6da649f084f64e56a2c42ed518e24';
  static const String _baseUrl = 'https://api.themoviedb.org/3';

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: _baseUrl,
      queryParameters: {
        'api_key': _apiKey,
        'language': 'en-US',
      },
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  Future<List<Movie>> searchMovies(String query) async {
    try {
      final response = await _dio.get(
        '/search/movie',
        queryParameters: {
          'query': query,
        },
      );

      final List results = response.data['results'] ?? [];
      return results.map((movie) => Movie.fromJson(movie)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<Movie>> getPopularMovies({int page = 1}) async {
    try {
      final response = await _dio.get(
        '/movie/popular',
        queryParameters: {
          'page': page,
        },
      );

      final List results = response.data['results'] ?? [];
      return results.map((movie) => Movie.fromJson(movie)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<Movie>> getTopRatedMovies({int page = 1}) async {
    try {
      final response = await _dio.get(
        '/movie/top_rated',
        queryParameters: {
          'page': page,
        },
      );

      final List results = response.data['results'] ?? [];
      return results.map((movie) => Movie.fromJson(movie)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<Map<String, dynamic>>> getGenres() async {
    try {
      final response = await _dio.get('/genre/movie/list');

      final List genres = response.data['genres'] ?? [];
      return genres
          .map(
            (genre) => {
              'id': genre['id'],
              'name': genre['name'],
            },
          )
          .toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<Movie>> getMoviesByGenre(int genreId) async {
    try {
      final response = await _dio.get(
        '/discover/movie',
        queryParameters: {
          'with_genres': genreId,
          'sort_by': 'popularity.desc',
        },
      );

      final List results = response.data['results'] ?? [];
      return results.map((movie) => Movie.fromJson(movie)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  String _handleError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timeout. Check your internet.';
      case DioExceptionType.receiveTimeout:
        return 'Server is slow, try again.';
      case DioExceptionType.badResponse:
        return 'Server error: ${e.response?.statusCode}';
      case DioExceptionType.connectionError:
        return 'No internet connection.';
      default:
        return 'Something went wrong.';
    }
  }
}