import 'package:flutter/material.dart';
import '../models/movie_model.dart';
import '../services/favorite_service.dart';

class MovieDetailsScreen extends StatefulWidget {
  final MovieModel movie;

  const MovieDetailsScreen({super.key, required this.movie});

  @override
  State<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  
  late bool isFavorite;

  @override
  void initState() {
    super.initState();
    isFavorite = FavoriteService.isFavorite(widget.movie.id);
  }

  @override
  Widget build(BuildContext context) {
    final movie = widget.movie;

    return Scaffold(
      backgroundColor: const Color(0xFF111111),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 420,
            pinned: true,
            backgroundColor: const Color(0xFF111111),
            iconTheme: const IconThemeData(color: Colors.white),
            actions: [
              IconButton(
                onPressed: () {
                setState(() {
                  FavoriteService.toggleFavorite(widget.movie.id);
                  isFavorite = FavoriteService.isFavorite(widget.movie.id);
                });                },
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? const Color(0xFFFF3300) : Colors.white,
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  movie.posterPath.isNotEmpty
                      ? Image.network(
                          movie.fullPosterUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _posterPlaceholder(),
                        )
                      : _posterPlaceholder(),
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Color(0xFF111111),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      _infoChip(Icons.star, movie.rating.toStringAsFixed(1)),
                      const SizedBox(width: 10),
                      _infoChip(
                        Icons.calendar_month,
                        movie.releaseDate.isEmpty
                            ? 'Unknown'
                            : movie.releaseDate,
                      ),
                    ],
                  ),
                  const SizedBox(height: 26),
                  const Text(
                    'Overview',
                    style: TextStyle(
                      color: Color(0xFF00CCFF),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    movie.overview.isEmpty
                        ? 'No overview available for this movie.'
                        : movie.overview,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFFF3300), size: 18),
          const SizedBox(width: 6),
          Text(text, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  Widget _posterPlaceholder() {
    return Container(
      color: const Color(0xFF1A1A1A),
      child: const Center(
        child: Icon(Icons.movie, color: Color(0xFF00CCFF), size: 80),
      ),
    );
  }
}