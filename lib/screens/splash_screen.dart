import 'package:flutter/material.dart';
import 'introduction_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _pulseController;
  late AnimationController _dotsController;

  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _dotsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();

    _fadeAnimation = CurvedAnimation(
      parent: _mainController,
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.35),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _mainController, curve: Curves.easeOutCubic),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.85,
      end: 1.0,
    ).animate(
      CurvedAnimation(parent: _mainController, curve: Curves.easeOutBack),
    );

    _mainController.forward();
  }

  @override
  void dispose() {
    _mainController.dispose();
    _pulseController.dispose();
    _dotsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C0E12),
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment(
                      -0.8 + (_pulseController.value * 0.4),
                      0.8 - (_pulseController.value * 0.4),
                    ),
                    radius: 1.2,
                    colors: [
                      Colors.red.withOpacity(0.22),
                      const Color(0xFF0C0E12),
                    ],
                  ),
                ),
              );
            },
          ),

          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Positioned(
                top: -120,
                right: -120,
                child: Container(
                  width: 420 + (_pulseController.value * 80),
                  height: 420 + (_pulseController.value * 80),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.cyan.withOpacity(0.25),
                        blurRadius: 140,
                        spreadRadius: 70,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Positioned(
                bottom: -120,
                left: -120,
                child: Container(
                  width: 420 + (_pulseController.value * 80),
                  height: 420 + (_pulseController.value * 80),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.red.withOpacity(0.28),
                        blurRadius: 150,
                        spreadRadius: 80,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _gradientText(
                        text: "MTV",
                        fontSize: 76,
                        italic: true,
                        colors: const [
                          Color(0xFFFF0000),
                          Color(0xFF990000),
                        ],
                      ),
                      _gradientText(
                        text: "MOVI",
                        fontSize: 76,
                        italic: false,
                        colors: const [
                          Color(0xFFE3E2E2),
                          Color(0xFF00CCFF),
                        ],
                      ),
                      const SizedBox(height: 28),
                      Container(
                        width: 90,
                        height: 3,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.red,
                              Colors.cyan,
                              Colors.red,
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 45),
                      const Text(
                        "PREMIUM CINEMA EXPERIENCE",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white54,
                          letterSpacing: 4,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 70),
                      AnimatedBuilder(
                        animation: _dotsController,
                        builder: (context, child) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(3, (index) {
                              final value =
                                  (_dotsController.value + index * 0.25) % 1;
                              return Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                width: 8,
                                height: 8 + (value * 8),
                                decoration: BoxDecoration(
                                  color: index == 1
                                      ? Colors.cyan
                                      : Colors.red,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: index == 1
                                          ? Colors.cyan.withOpacity(0.7)
                                          : Colors.red.withOpacity(0.7),
                                      blurRadius: 18,
                                    ),
                                  ],
                                ),
                              );
                            }),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            bottom: 38,
            left: 0,
            right: 0,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (_, _, _) => const IntroductionScreen(),
                    transitionDuration: const Duration(milliseconds: 700),
                    transitionsBuilder: (_, anim, _, child) {
                      final curved = CurvedAnimation(
                        parent: anim,
                        curve: Curves.easeInOut,
                      );
                      return FadeTransition(
                        opacity: curved,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0, 0.04),
                            end: Offset.zero,
                          ).animate(curved),
                          child: child,
                        ),
                      );
                    },
                  ),
                );
              },
              child: AnimatedBuilder(
                animation: _pulseController,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, -10 * _pulseController.value),
                    child: const Icon(
                      Icons.keyboard_double_arrow_right,
                      color: Color(0xFF00CCFF),
                      size: 38,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _gradientText({
    required String text,
    required double fontSize,
    required bool italic,
    required List<Color> colors,
  }) {
    return ShaderMask(
      shaderCallback: (bounds) {
        return LinearGradient(colors: colors).createShader(bounds);
      },
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize,
          fontWeight: FontWeight.w900,
          fontStyle: italic ? FontStyle.italic : FontStyle.normal,
          letterSpacing: -2,
          shadows: [
            Shadow(
              color: Colors.red.withOpacity(0.6),
              blurRadius: 25,
            ),
            Shadow(
              color: Colors.cyan.withOpacity(0.35),
              blurRadius: 45,
            ),
          ],
        ),
      ),
    );
  }
}