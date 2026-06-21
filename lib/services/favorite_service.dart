class FavoriteService {
  static final Set<int> _favoriteMovieIds = {};

  static bool isFavorite(int movieId) {
    return _favoriteMovieIds.contains(movieId);
  }

  static void toggleFavorite(int movieId) {
    if (_favoriteMovieIds.contains(movieId)) {
      _favoriteMovieIds.remove(movieId);
    } else {
      _favoriteMovieIds.add(movieId);
    }
  }
}