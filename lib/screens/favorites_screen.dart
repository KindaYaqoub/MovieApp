import 'package:flutter/material.dart';

import '../models/movie_model.dart';
import '../services/favorite_service.dart';
import 'movie_details_screen.dart';
import 'favorite_statistics_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<MovieModel> favoriteMovies = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final movies = await FavoriteService.getFavorites();

    if (!mounted) return;

    setState(() {
      favoriteMovies = movies;
      isLoading = false;
    });
  }

  Future<void> _removeFavorite(int movieId) async {
    await FavoriteService.removeFavorite(movieId);
    await _loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyMedium?.color;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'Favorite Movies',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            tooltip: 'Favorite Statistics',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FavoriteStatisticsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF00CCFF),
              ),
            )
          : favoriteMovies.isEmpty
              ? Center(
                  child: Text(
                    'No favorite movies yet',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 18,
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: favoriteMovies.length,
                  itemBuilder: (context, index) {
                    final movie = favoriteMovies[index];

                    return Card(
                      color: Theme.of(context).cardColor,
                      margin: const EdgeInsets.all(10),
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  MovieDetailsScreen(movie: movie),
                            ),
                          );
                        },
                        leading: movie.posterPath.isNotEmpty
                            ? Image.network(
                                movie.fullPosterUrl,
                                width: 50,
                                fit: BoxFit.cover,
                              )
                            : Icon(Icons.movie, color: textColor),
                        title: Text(
                          movie.title,
                          style: TextStyle(color: textColor),
                        ),
                        subtitle: Text(
                          movie.releaseDate,
                          style: TextStyle(
                            color: textColor?.withValues(alpha: 0.7),
                          ),
                        ),
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.favorite,
                            color: Color(0xFFFF3300),
                          ),
                          onPressed: () async {
                            await _removeFavorite(movie.id);
                          },
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
