import 'package:flutter/material.dart';

import 'home_screen.dart';
import 'search_screen.dart';
import 'favorites_screen.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  Widget _buildFeatureCard(
    BuildContext context,
    IconData icon,
    String text,
    VoidCallback onTap,
  ) {
    final textColor = Theme.of(context).textTheme.bodyMedium?.color;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
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
            const Icon(Icons.arrow_forward_ios, size: 14),
          ],
        ),
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
              'About MTV MOVI',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textColor,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(


              'MTV MOVI brings the world of movies to your fingertips. Explore trending and top-rated films, search for any movie instantly, view detailed information, and keep track of your favorite films.',


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

            _buildFeatureCard(
              context,
              Icons.movie_creation_outlined,
              'Browse popular and top-rated movies',
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomeScreen(),
                  ),
                );
              },
            ),

            const SizedBox(height: 10),

            _buildFeatureCard(
              context,
              Icons.search,
              'Search for movies',
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SearchScreen(),
                  ),
                );
              },
            ),

            const SizedBox(height: 10),

            _buildFeatureCard(
              context,
              Icons.favorite,
              'Save favorite movies',
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FavoritesScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}