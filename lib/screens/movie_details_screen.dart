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
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkFavorite();
  }

  Future<void> _checkFavorite() async {
    final value = await FavoriteService.isFavorite(widget.movie.id);

    if (!mounted) return;

    setState(() {
      isFavorite = value;
    });
  }

  Future<void> _toggleFavorite() async {
    await FavoriteService.toggleFavorite(widget.movie);

    if (!mounted) return;

    setState(() {
      isFavorite = !isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    final movie = widget.movie;
    final textColor = Theme.of(context).textTheme.bodyMedium?.color;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 420,
            pinned: true,
            actions: [
              IconButton(
                onPressed: _toggleFavorite,
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
                          errorBuilder: (_, __, ___) => _posterPlaceholder(context),
                        )
                      : _posterPlaceholder(context),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Theme.of(context).scaffoldBackgroundColor,
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
                    style: TextStyle(
                      color: textColor,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      _infoChip(context, Icons.star, movie.rating.toStringAsFixed(1)),
                      const SizedBox(width: 10),
                      _infoChip(
                        context,
                        Icons.calendar_month,
                        movie.releaseDate.isEmpty ? 'Unknown' : movie.releaseDate,
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
                    style: TextStyle(
                      color: textColor?.withValues(alpha: 0.75),
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

  Widget _infoChip(BuildContext context, IconData icon, String text) {
    final textColor = Theme.of(context).textTheme.bodyMedium?.color;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFFF3300), size: 18),
          const SizedBox(width: 6),
          Text(text, style: TextStyle(color: textColor)),
        ],
      ),
    );
  }

  Widget _posterPlaceholder(BuildContext context) {
    return Container(
      color: Theme.of(context).cardColor,
      child: const Center(
        child: Icon(Icons.movie, color: Color(0xFF00CCFF), size: 80),
      ),
    );
  }
}