import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'register_screen.dart';

class IntroductionScreen extends StatefulWidget {
  const IntroductionScreen({super.key});

  @override
  State<IntroductionScreen> createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroductionScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _breathingController;
  late AnimationController _particleController;
  late AnimationController _buttonPressController;

  late Animation<double> _fadeAnim;
  late Animation<Offset> _titleSlide;
  late Animation<Offset> _subtitleSlide;
  late Animation<double> _contentFade;
  late Animation<double> _breathingAnim;
  late Animation<double> _buttonScaleAnim;

  Timer? _typewriterTimer;

  static const String _fullText =
      'Explore a collection of movies from different genres and discover your next favorite film. '
      'We hope you enjoy your experience with MTV MOVI.';

  String _displayedText = '';
  int _charIndex = 0;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );

    _breathingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    _buttonPressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );

    _fadeAnim =
        CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);

    _titleSlide = Tween<Offset>(
      begin: const Offset(0, 0.4),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: const Interval(0.0, 0.65, curve: Curves.easeOutCubic),
    ));

    _subtitleSlide = Tween<Offset>(
      begin: const Offset(0, 0.4),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: const Interval(0.15, 0.8, curve: Curves.easeOutCubic),
    ));

    _contentFade = CurvedAnimation(
      parent: _slideController,
      curve: const Interval(0.45, 1.0, curve: Curves.easeOut),
    );

    _breathingAnim = Tween<double>(begin: 0.93, end: 1.07).animate(
      CurvedAnimation(parent: _breathingController, curve: Curves.easeInOut),
    );

    _buttonScaleAnim = Tween<double>(begin: 1.0, end: 0.94).animate(
      CurvedAnimation(parent: _buttonPressController, curve: Curves.easeInOut),
    );

    _fadeController.forward();
    Future.delayed(const Duration(milliseconds: 150), () {
      if (mounted) _slideController.forward();
    });
    Future.delayed(const Duration(milliseconds: 950), () {
      if (mounted) _startTypewriter();
    });
  }

  void _startTypewriter() {
    _typewriterTimer = Timer.periodic(const Duration(milliseconds: 15), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      if (_charIndex >= _fullText.length) {
        t.cancel();
        return;
      }
      setState(() {
        _charIndex++;
        _displayedText = _fullText.substring(0, _charIndex);
      });
    });
  }

  @override
  void dispose() {
    _typewriterTimer?.cancel();
    _fadeController.dispose();
    _slideController.dispose();
    _breathingController.dispose();
    _particleController.dispose();
    _buttonPressController.dispose();
    super.dispose();
  }

  Future<void> _onGetStarted() async {
    await _buttonPressController.forward();
    await _buttonPressController.reverse();
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, _, _) => const RegisterScreen(),
        transitionDuration: const Duration(milliseconds: 600),
        transitionsBuilder: (_, anim, _, child) => FadeTransition(
          opacity: CurvedAnimation(parent: anim, curve: Curves.easeInOut),
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xFF0C0E12),
      body: FadeTransition(
        opacity: _fadeAnim,
        child: Stack(
          children: [
            // Background radial gradient
            AnimatedBuilder(
              animation: _breathingController,
              builder: (context, child) {
                return Container(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment(
                        -0.8 + (_breathingController.value * 0.4),
                        0.8 - (_breathingController.value * 0.4),
                      ),
                      radius: 1.2,
                      colors: [
                        Colors.red.withValues(alpha: 0.22),
                        const Color(0xFF0C0E12),
                      ],
                    ),
                  ),
                );
              },
            ),

            // Floating glow particles
            AnimatedBuilder(
              animation: _particleController,
              builder: (_, _) => CustomPaint(
                painter: _ParticlePainter(_particleController.value),
                size: size,
              ),
            ),

            // Cyan glow — top right
            Positioned(
              top: -120,
              right: -120,
              child: AnimatedBuilder(
                animation: _breathingController,
                builder: (_, _) => Container(
                  width: 420 + (_breathingController.value * 80),
                  height: 420 + (_breathingController.value * 80),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.cyan.withValues(alpha: 0.25),
                        blurRadius: 140,
                        spreadRadius: 70,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Red glow — bottom left
            Positioned(
              bottom: -120,
              left: -120,
              child: AnimatedBuilder(
                animation: _breathingController,
                builder: (_, _) => Container(
                  width: 420 + (_breathingController.value * 80),
                  height: 420 + (_breathingController.value * 80),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.red.withValues(alpha: 0.28),
                        blurRadius: 150,
                        spreadRadius: 80,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Main scrollable content
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 36),

                    _buildMovieIcon(),

                    const SizedBox(height: 28),

                    SlideTransition(
                      position: _titleSlide,
                      child: FadeTransition(
                        opacity: CurvedAnimation(
                          parent: _slideController,
                          curve:
                              const Interval(0.0, 0.7, curve: Curves.easeOut),
                        ),
                        child: _buildTitle(),
                      ),
                    ),

                    const SizedBox(height: 10),

                    SlideTransition(
                      position: _subtitleSlide,
                      child: FadeTransition(
                        opacity: CurvedAnimation(
                          parent: _slideController,
                          curve: const Interval(0.15, 0.8,
                              curve: Curves.easeOut),
                        ),
                        child: _buildSubtitle(),
                      ),
                    ),

                    const SizedBox(height: 14),

                    FadeTransition(
                      opacity: CurvedAnimation(
                        parent: _slideController,
                        curve:
                            const Interval(0.2, 0.85, curve: Curves.easeOut),
                      ),
                      child: _buildDivider(),
                    ),

                    const SizedBox(height: 28),

                    FadeTransition(
                      opacity: _contentFade,
                      child: _buildDescriptionCard(),
                    ),

                    const SizedBox(height: 20),

                    FadeTransition(
                      opacity: _contentFade,
                      child: _buildQuote(),
                    ),

                    const SizedBox(height: 36),

                    FadeTransition(
                      opacity: _contentFade,
                      child: _buildGetStartedButton(),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Movie icon with breathing animation + Hero tag 

  Widget _buildMovieIcon() {
    return AnimatedBuilder(
      animation: _breathingAnim,
      builder: (_, child) => Transform.scale(
        scale: _breathingAnim.value,
        child: child,
      ),
      child: Hero(
        tag: 'movie_icon_hero',
        child: Container(
          width: 110,
          height: 110,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF161820),
            border: Border.all(
              color: Colors.cyan.withValues(alpha: 0.35),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.cyan.withValues(alpha: 0.25),
                blurRadius: 35,
                spreadRadius: 8,
              ),
              BoxShadow(
                color: Colors.red.withValues(alpha: 0.18),
                blurRadius: 45,
                spreadRadius: 10,
              ),
            ],
          ),
          child: const Icon(
            Icons.movie_filter_rounded,
            color: Color(0xFF00CCFF),
            size: 56,
          ),
        ),
      ),
    );
  }

  // Title 

  Widget _buildTitle() {
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        colors: [Color(0xFFFF3333), Color(0xFFFFFFFF), Color(0xFF00CCFF)],
        stops: [0.0, 0.5, 1.0],
      ).createShader(bounds),
      child: const Text(
        'Welcome to MTV MOVI',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: 26,
          fontWeight: FontWeight.w900,
          letterSpacing: -0.3,
          height: 1.25,
        ),
      ),
    );
  }

  // Subtitle 

  Widget _buildSubtitle() {
    return Text(
      'YOUR ULTIMATE MOVIE EXPERIENCE',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.white.withValues(alpha: 0.5),
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 3.5,
      ),
    );
  }

  //  Gradient divider 

  Widget _buildDivider() {
    return Container(
      width: 80,
      height: 2,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.red, Colors.cyan, Colors.red],
        ),
        borderRadius: BorderRadius.all(Radius.circular(1)),
      ),
    );
  }

  // Glowing description card with typewriter text 

  Widget _buildDescriptionCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: const Color(0xFF13161D),
        borderRadius: BorderRadius.circular(16),
        border:
            Border.all(color: Colors.white.withValues(alpha: 0.07), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.cyan.withValues(alpha: 0.07),
            blurRadius: 30,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: Colors.red.withValues(alpha: 0.07),
            blurRadius: 30,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 3,
                height: 16,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.red, Colors.cyan],
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(1.5)),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'ABOUT',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.35),
                  fontSize: 9,
                  letterSpacing: 3.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          RichText(
            text: TextSpan(
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 14,
                height: 1.8,
                letterSpacing: 0.2,
              ),
              children: [
                TextSpan(text: _displayedText),
                if (_charIndex < _fullText.length)
                  const WidgetSpan(
                    child: _BlinkingCursor(),
                    alignment: PlaceholderAlignment.middle,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //  Quote 

  Widget _buildQuote() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.format_quote,
              color: Colors.red.withValues(alpha: 0.45), size: 18),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              'Every movie tells a story. Start your journey today.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.4),
                fontSize: 13,
                fontStyle: FontStyle.italic,
                letterSpacing: 0.4,
                height: 1.6,
              ),
            ),
          ),
          const SizedBox(width: 6),
          Icon(Icons.format_quote,
              color: Colors.cyan.withValues(alpha: 0.45), size: 18),
        ],
      ),
    );
  }

  // Get Started button — scale press + breathing glow 

  Widget _buildGetStartedButton() {
    return AnimatedBuilder(
      animation: _buttonPressController,
      builder: (_, child) => Transform.scale(
        scale: _buttonScaleAnim.value,
        child: child,
      ),
      child: AnimatedBuilder(
        animation: _breathingController,
        builder: (_, child) {
          final g = _breathingController.value;
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.red.withValues(alpha: 0.28 + 0.14 * g),
                  blurRadius: 18 + 12 * g,
                  offset: const Offset(-5, 6),
                ),
                BoxShadow(
                  color: Colors.cyan.withValues(alpha: 0.28 + 0.14 * g),
                  blurRadius: 18 + 12 * g,
                  offset: const Offset(5, 6),
                ),
              ],
            ),
            child: child,
          );
        },
        child: GestureDetector(
          onTap: _onGetStarted,
          child: Container(
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              gradient: const LinearGradient(
                colors: [
                  Color(0xFFCC0000),
                  Color(0xFF880088),
                  Color(0xFF0099CC),
                ],
              ),
            ),
            child: const Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'GET STARTED',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 3,
                    ),
                  ),
                  SizedBox(width: 10),
                  Icon(Icons.arrow_forward_rounded,
                      color: Colors.white, size: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Blinking cursor 

class _BlinkingCursor extends StatefulWidget {
  const _BlinkingCursor();

  @override
  State<_BlinkingCursor> createState() => _BlinkingCursorState();
}

class _BlinkingCursorState extends State<_BlinkingCursor>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 530),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: const Text(
        ' |',
        style: TextStyle(
          color: Color(0xFF00CCFF),
          fontSize: 14,
          fontWeight: FontWeight.w300,
          height: 1.8,
        ),
      ),
    );
  }
}

//  Floating glow particle painter

class _ParticlePainter extends CustomPainter {
  final double progress;

  _ParticlePainter(this.progress);

  
  static const List<List<double>> _data = [
    [0.10, 0.18, 45, 1, 0.00],
    [0.90, 0.12, 55, 0, 0.18],
    [0.78, 0.60, 40, 1, 0.35],
    [0.06, 0.70, 50, 0, 0.52],
    [0.55, 0.90, 38, 1, 0.68],
    [0.92, 0.82, 44, 0, 0.82],
  ];

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in _data) {
      final t = (progress + p[4]) % 1.0;
      final angle = t * 2 * pi;
      final dx = cos(angle) * 16.0;
      final dy = sin(angle) * 12.0;
      final isRed = p[3] == 1;

      canvas.drawCircle(
        Offset(size.width * p[0] + dx, size.height * p[1] + dy),
        p[2],
        Paint()
          ..color = (isRed ? Colors.red : Colors.cyan).withValues(alpha: 0.12)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, p[2] * 0.65),
      );
    }
  }

  @override
  bool shouldRepaint(_ParticlePainter old) => old.progress != progress;
}
