import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class MagicParticlesBackground extends StatefulWidget {
  const MagicParticlesBackground({super.key});

  @override
  State<MagicParticlesBackground> createState() => _MagicParticlesBackgroundState();
}

class _MagicParticlesBackgroundState extends State<MagicParticlesBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final List<_Particle> _particles = [];
  final math.Random _random = math.Random(42);
  Offset _mousePosition = Offset.zero;

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 45; i++) {
      _particles.add(
        _Particle(
          x: _random.nextDouble(),
          y: _random.nextDouble(),
          radius: _random.nextDouble() * 2.2 + 1.0,
          speedX: (_random.nextDouble() - 0.5) * 0.00045,
          speedY: (_random.nextDouble() - 0.5) * 0.00045,
          baseAlpha: _random.nextDouble() * 0.4 + 0.15,
        ),
      );
    }

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_controller, ThemeController.instance]),
      builder: (context, child) {
        return MouseRegion(
          onHover: (event) {
            _mousePosition = event.localPosition;
          },
          child: CustomPaint(
            painter: _ParticlesPainter(
              particles: _particles,
              mousePos: _mousePosition,
              primaryColor: AppColors.primary,
              secondaryColor: AppColors.secondary,
            ),
            child: const SizedBox.expand(),
          ),
        );
      },
    );
  }
}

class _Particle {
  _Particle({
    required this.x,
    required this.y,
    required this.radius,
    required this.speedX,
    required this.speedY,
    required this.baseAlpha,
  });

  double x;
  double y;
  final double radius;
  final double speedX;
  final double speedY;
  final double baseAlpha;

  void update() {
    x += speedX;
    y += speedY;

    if (x < 0) x = 1.0;
    if (x > 1.0) x = 0;
    if (y < 0) y = 1.0;
    if (y > 1.0) y = 0;
  }
}

class _ParticlesPainter extends CustomPainter {
  _ParticlesPainter({
    required this.particles,
    required this.mousePos,
    required this.primaryColor,
    required this.secondaryColor,
  });

  final List<_Particle> particles;
  final Offset mousePos;
  final Color primaryColor;
  final Color secondaryColor;

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Draw glowing ambient gradient orbs in the background
    final orbPaint1 = Paint()
      ..shader = RadialGradient(
        colors: [
          primaryColor.withValues(alpha: .12),
          primaryColor.withValues(alpha: .03),
          Colors.transparent,
        ],
        stops: const [0.0, 0.45, 1.0],
      ).createShader(Rect.fromCircle(center: Offset(size.width * 0.85, size.height * 0.15), radius: 360));
    canvas.drawCircle(Offset(size.width * 0.85, size.height * 0.15), 360, orbPaint1);

    final orbPaint2 = Paint()
      ..shader = RadialGradient(
        colors: [
          secondaryColor.withValues(alpha: .09),
          secondaryColor.withValues(alpha: .02),
          Colors.transparent,
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromCircle(center: Offset(size.width * 0.1, size.height * 0.65), radius: 340));
    canvas.drawCircle(Offset(size.width * 0.1, size.height * 0.65), 340, orbPaint2);

    final orbPaint3 = Paint()
      ..shader = RadialGradient(
        colors: [
          primaryColor.withValues(alpha: .07),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(center: Offset(size.width * 0.5, size.height * 0.95), radius: 380));
    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.95), 380, orbPaint3);

    // 2. Update & Draw Constellation Particles & Links
    final points = <Offset>[];
    for (final p in particles) {
      p.update();
      points.add(Offset(p.x * size.width, p.y * size.height));
    }

    const maxDist = 120.0;
    final linePaint = Paint()..strokeWidth = 0.8;

    for (int i = 0; i < points.length; i++) {
      for (int j = i + 1; j < points.length; j++) {
        final dist = (points[i] - points[j]).distance;
        if (dist < maxDist) {
          final alpha = (1.0 - (dist / maxDist)) * 0.22;
          linePaint.color = primaryColor.withValues(alpha: alpha);
          canvas.drawLine(points[i], points[j], linePaint);
        }
      }
    }

    final dotPaint = Paint()..style = PaintingStyle.fill;
    for (int i = 0; i < particles.length; i++) {
      final p = particles[i];
      final pos = points[i];

      dotPaint.color = (i % 3 == 0 ? secondaryColor : primaryColor)
          .withValues(alpha: p.baseAlpha);
      canvas.drawCircle(pos, p.radius, dotPaint);

      // Subtle glow on larger particles
      if (p.radius > 2.0) {
        dotPaint.color = primaryColor.withValues(alpha: p.baseAlpha * 0.35);
        canvas.drawCircle(pos, p.radius * 2.2, dotPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlesPainter oldDelegate) => true;
}
