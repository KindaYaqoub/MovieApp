import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  Widget _buildFeatureCard(BuildContext context, IconData icon, String text) {
    final textColor = Theme.of(context).textTheme.bodyMedium?.color;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF00CCFF), size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: textColor,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyMedium?.color;
    final mutedColor = textColor?.withValues(alpha: 0.7);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('About App'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 20),

            Container(
              width: 105,
              height: 105,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).cardColor,
                border: Border.all(
                  color: const Color(0xFF00CCFF),
                  width: 1.5,
                ),
              ),
              child: const Icon(
                Icons.local_movies_rounded,
                size: 58,
                color: Color(0xFF00CCFF),
              ),
            ),

            const SizedBox(height: 20),

            Text(
              'Movie Catalog',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textColor,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              'Discover popular and top-rated movies, explore details, search easily, and save your favorite movies in one place.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: mutedColor,
                fontSize: 16,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 30),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Features',
                style: TextStyle(
                  color: textColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 14),

            _buildFeatureCard(context, Icons.trending_up, 'Browse popular movies'),
            const SizedBox(height: 10),
            _buildFeatureCard(context, Icons.star, 'View top-rated movies'),
            const SizedBox(height: 10),
            _buildFeatureCard(context, Icons.search, 'Search for movies'),
            const SizedBox(height: 10),
            _buildFeatureCard(context, Icons.favorite, 'Save favorite movies'),
            const SizedBox(height: 10),
            _buildFeatureCard(context, Icons.person, 'User login and account support'),

            const SizedBox(height: 30),

            Divider(color: Theme.of(context).dividerColor),

            const SizedBox(height: 12),

            Text(
              'Version 1.0.0',
              style: TextStyle(
                color: textColor?.withValues(alpha: 0.6),
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Developed by Group D',
              style: TextStyle(
                color: Color(0xFFFF3300),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}