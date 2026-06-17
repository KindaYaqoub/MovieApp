import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  late AnimationController _breathingController;
  late AnimationController _particleController;
  late AnimationController _fadeController;
  late AnimationController _buttonPressController;

  late Animation<double> _fadeAnim;
  late Animation<double> _buttonScaleAnim;

  bool _loading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  final _authService = AuthService();

  @override
  void initState() {
    super.initState();

    _breathingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _buttonPressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );

    _fadeAnim =
        CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);

    _buttonScaleAnim = Tween<double>(begin: 1.0, end: 0.94).animate(
      CurvedAnimation(parent: _buttonPressController, curve: Curves.easeInOut),
    );

    _fadeController.forward();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _breathingController.dispose();
    _particleController.dispose();
    _fadeController.dispose();
    _buttonPressController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);
    try {
      await _authService.register(
        fullName: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      if (!mounted) return;
      _showSnackBar('Account created successfully!', isError: false);
      await Future.delayed(const Duration(milliseconds: 600));
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, _, _) => const LoginScreen(),
          transitionDuration: const Duration(milliseconds: 600),
          transitionsBuilder: (_, anim, _, child) => FadeTransition(
            opacity: CurvedAnimation(parent: anim, curve: Curves.easeInOut),
            child: child,
          ),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (mounted) _showSnackBar(_firebaseError(e.code));
    } catch (_) {
      if (mounted) _showSnackBar('Something went wrong. Please try again.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _showSnackBar(String message, {bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor:
            isError ? const Color(0xFFCC0000) : Colors.green.shade700,
        behavior: SnackBarBehavior.floating,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  String _firebaseError(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'This email is already registered.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'weak-password':
        return 'Password must be at least 6 characters.';
      case 'network-request-failed':
        return 'No internet connection.';
      default:
        return 'Registration failed. Please try again.';
    }
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
            // Animated background — matches Splash / Intro
            AnimatedBuilder(
              animation: _breathingController,
              builder: (_, _) => Container(
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
              ),
            ),

            // Floating particles
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

            // Scrollable form
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 36),
                      _buildLogo(),
                      const SizedBox(height: 24),
                      _buildTitle('Create Account'),
                      const SizedBox(height: 8),
                      _buildSubtitle('JOIN MTV MOVI TODAY'),
                      const SizedBox(height: 12),
                      _buildDivider(),
                      const SizedBox(height: 32),

                      _buildField(
                        controller: _nameController,
                        label: 'Full Name',
                        icon: Icons.person_outline_rounded,
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Full name is required'
                            : null,
                      ),
                      const SizedBox(height: 16),

                      _buildField(
                        controller: _emailController,
                        label: 'Email',
                        icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return 'Email is required';
                          }
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                              .hasMatch(v.trim())) {
                            return 'Enter a valid email address';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      _buildField(
                        controller: _passwordController,
                        label: 'Password',
                        icon: Icons.lock_outline_rounded,
                        obscure: _obscurePassword,
                        suffixIcon: _visibilityToggle(
                          visible: _obscurePassword,
                          onTap: () => setState(
                              () => _obscurePassword = !_obscurePassword),
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return 'Password is required';
                          }
                          if (v.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      _buildField(
                        controller: _confirmPasswordController,
                        label: 'Confirm Password',
                        icon: Icons.lock_outline_rounded,
                        obscure: _obscureConfirmPassword,
                        suffixIcon: _visibilityToggle(
                          visible: _obscureConfirmPassword,
                          onTap: () => setState(() =>
                              _obscureConfirmPassword =
                                  !_obscureConfirmPassword),
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return 'Please confirm your password';
                          }
                          if (v != _passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 32),
                      _buildActionButton(
                        label: 'CREATE ACCOUNT',
                        onTap: _loading ? null : _register,
                      ),
                      const SizedBox(height: 20),
                      _buildFooterLink(
                        prompt: 'Already have an account? ',
                        linkText: 'Login',
                        onTap: () => Navigator.pushReplacement(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (_, _, _) => const LoginScreen(),
                            transitionDuration:
                                const Duration(milliseconds: 500),
                            transitionsBuilder: (_, anim, _, child) =>
                                FadeTransition(
                              opacity: CurvedAnimation(
                                  parent: anim, curve: Curves.easeInOut),
                              child: child,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Shared UI helpers 

  Widget _buildLogo() {
    return AnimatedBuilder(
      animation: _breathingController,
      builder: (_, child) => Transform.scale(
        scale: 0.93 + 0.07 * _breathingController.value,
        child: child,
      ),
      child: Container(
        width: 90,
        height: 90,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFF161820),
          border: Border.all(
              color: Colors.cyan.withValues(alpha: 0.35), width: 1.5),
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
        child: const Icon(Icons.movie_filter_rounded,
            color: Color(0xFF00CCFF), size: 44),
      ),
    );
  }

  Widget _buildTitle(String text) {
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        colors: [Color(0xFFFF3333), Color(0xFFFFFFFF), Color(0xFF00CCFF)],
        stops: [0.0, 0.5, 1.0],
      ).createShader(bounds),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 26,
          fontWeight: FontWeight.w900,
          letterSpacing: -0.3,
        ),
      ),
    );
  }

  Widget _buildSubtitle(String text) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.white.withValues(alpha: 0.5),
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 3.5,
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 80,
      height: 2,
      decoration: const BoxDecoration(
        gradient:
            LinearGradient(colors: [Colors.red, Colors.cyan, Colors.red]),
        borderRadius: BorderRadius.all(Radius.circular(1)),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    bool obscure = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
            color: Colors.white.withValues(alpha: 0.45), fontSize: 13),
        prefixIcon: Icon(icon, color: Colors.white38, size: 20),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: const Color(0xFF13161D),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide:
              BorderSide(color: Colors.white.withValues(alpha: 0.08)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide:
              const BorderSide(color: Color(0xFF00CCFF), width: 1.2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide:
              const BorderSide(color: Color(0xFFCC0000), width: 1.2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide:
              const BorderSide(color: Color(0xFFCC0000), width: 1.2),
        ),
        errorStyle:
            const TextStyle(color: Color(0xFFFF4444), fontSize: 12),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }

  Widget _visibilityToggle({
    required bool visible,
    required VoidCallback onTap,
  }) {
    return IconButton(
      icon: Icon(
        visible ? Icons.visibility_off_outlined : Icons.visibility_outlined,
        color: Colors.white38,
        size: 20,
      ),
      onPressed: onTap,
    );
  }

  Widget _buildActionButton({
    required String label,
    required VoidCallback? onTap,
  }) {
    return AnimatedBuilder(
      animation: _buttonPressController,
      builder: (_, child) =>
          Transform.scale(scale: _buttonScaleAnim.value, child: child),
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
          onTap: onTap,
          onTapDown: onTap == null
              ? null
              : (_) => _buttonPressController.forward(),
          onTapUp: onTap == null
              ? null
              : (_) => _buttonPressController.reverse(),
          onTapCancel: () => _buttonPressController.reverse(),
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
            child: Center(
              child: _loading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2.5),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          label,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 2.5,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Icon(Icons.arrow_forward_rounded,
                            color: Colors.white, size: 20),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFooterLink({
    required String prompt,
    required String linkText,
    required VoidCallback onTap,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          prompt,
          style: TextStyle(
              color: Colors.white.withValues(alpha: 0.45), fontSize: 13),
        ),
        GestureDetector(
          onTap: onTap,
          child: Text(
            linkText,
            style: const TextStyle(
              color: Color(0xFF00CCFF),
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

// Floating glow particle painter 

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
          ..color =
              (isRed ? Colors.red : Colors.cyan).withValues(alpha: 0.12)
          ..maskFilter =
              MaskFilter.blur(BlurStyle.normal, p[2] * 0.65),
      );
    }
  }

  @override
  bool shouldRepaint(_ParticlePainter old) => old.progress != progress;
}
