import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C0E12),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(
                children: [
                  Hero(
                    tag: 'movie_icon_hero',
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF161820),
                        border: Border.all(
                          color: Colors.cyan.withValues(alpha: 0.35),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.cyan.withValues(alpha: 0.2),
                            blurRadius: 14,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.movie_filter_rounded,
                        color: Color(0xFF00CCFF),
                        size: 22,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [Color(0xFFFF3333), Color(0xFF00CCFF)],
                    ).createShader(bounds),
                    child: const Text(
                      'MTV MOVI',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Placeholder content
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.movie_creation_outlined,
                      color: Colors.white.withValues(alpha: 0.08),
                      size: 90,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'HOME',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.25),
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                        letterSpacing: 6,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'COMING SOON',
                      style: TextStyle(
                        color: Colors.cyan.withValues(alpha: 0.35),
                        fontSize: 10,
                        letterSpacing: 4,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
