import 'package:flutter/material.dart';
import '../models/movie_model.dart';
import '../services/favorite_service.dart';

class FavoriteStatisticsScreen extends StatefulWidget {
  const FavoriteStatisticsScreen({super.key});

  @override
  State<FavoriteStatisticsScreen> createState() =>
      _FavoriteStatisticsScreenState();
}

class _FavoriteStatisticsScreenState extends State<FavoriteStatisticsScreen> {
  late Future<List<MovieModel>> _favoritesFuture;

  @override
  void initState() {
    super.initState();
    _favoritesFuture = FavoriteService.getFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111111),
      appBar: AppBar(
        title: const Text('Favorite Statistics'),
        backgroundColor: const Color(0xFF111111),
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<MovieModel>>(
        future: _favoritesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF00CCFF)),
            );
          }

          final favorites = snapshot.data ?? [];

          if (favorites.isEmpty) {
            return const Center(
              child: Text(
                'No favorite movies yet.',
                style: TextStyle(color: Colors.white70, fontSize: 18),
              ),
            );
          }

          final total = favorites.length;

          final averageRating =
              favorites.map((m) => m.rating).reduce((a, b) => a + b) / total;

          final highestRated =
              favorites.reduce((a, b) => a.rating >= b.rating ? a : b);

          final latestRelease = favorites.reduce(
            (a, b) => a.releaseDate.compareTo(b.releaseDate) >= 0 ? a : b,
          );

          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _statCard(
                  title: 'Total Favorite Movies',
                  value: '$total',
                  icon: Icons.favorite,
                ),
                _statCard(
                  title: 'Average Rating',
                  value: averageRating.toStringAsFixed(1),
                  icon: Icons.star,
                ),
                _statCard(
                  title: 'Highest Rated Movie',
                  value: highestRated.title,
                  icon: Icons.trending_up,
                ),
                _statCard(
                  title: 'Newest Favorite Movie',
                  value: latestRelease.releaseDate,
                  icon: Icons.calendar_month,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _statCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFFF3300), size: 28),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(color: Colors.white70, fontSize: 15),
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
