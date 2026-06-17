class Movie {
  final int id;
  final String title;
  final String overview;
  final String posterPath;
  final double rating;
  final String releaseDate;
  final List<int> genreIds;

  Movie({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.rating,
    required this.releaseDate,
    required this.genreIds,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      overview: json['overview'] ?? '',
      posterPath: json['poster_path'] ?? '',
      rating: (json['vote_average'] ?? 0.0).toDouble(),
      releaseDate: json['release_date'] ?? '',
      genreIds: List<int>.from(json['genre_ids'] ?? []),
    );
  }

  double get voteAverage => rating;

  String get fullPosterUrl {
    if (posterPath.isEmpty) return '';
    return 'https://image.tmdb.org/t/p/w500$posterPath';
  }

  String get year {
    if (releaseDate.isEmpty || releaseDate.length < 4) return '';
    return releaseDate.substring(0, 4);
  }
}

typedef MovieModel = Movie;