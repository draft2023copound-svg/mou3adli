import 'dart:math';
import 'package:flutter/material.dart';
import '../utils/constants.dart';

class _Particle {
  Offset position;
  final Offset velocity;
  final Color color;
  final double size;
  double life;
  final double maxLife;

  _Particle({
    required this.position,
    required this.velocity,
    required this.color,
    required this.size,
    required this.maxLife,
  }) : life = maxLife;
}

class ExplosionAnimation extends StatefulWidget {
  final Offset center;
  final Color color;
  final int particleCount;
  final double maxRadius;
  final VoidCallback? onComplete;

  const ExplosionAnimation({
    super.key,
    required this.center,
    required this.color,
    this.particleCount = 12,
    this.maxRadius = 60.0,
    this.onComplete,
  });

  @override
  State<ExplosionAnimation> createState() => _ExplosionAnimationState();
}

class _ExplosionAnimationState extends State<ExplosionAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<_Particle> _particles;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: kExplosionDuration,
    );

    _initializeParticles();
    _controller.forward().then((_) => widget.onComplete?.call());
  }

  void _initializeParticles() {
    final random = Random();
    _particles = List.generate(widget.particleCount, (i) {
      final angle = (i / widget.particleCount) * 2 * pi + (random.nextDouble() - 0.5) * 0.5;
      final speed = widget.maxRadius * (0.5 + random.nextDouble() * 0.5);
      return _Particle(
        position: Offset.zero,
        velocity: Offset(cos(angle) * speed, sin(angle) * speed),
        color: widget.color,
        size: 4 + random.nextDouble() * 6,
        maxLife: 1.0,
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = _controller.value;
        return CustomPaint(
          size: Size.infinite,
          painter: _ExplosionPainter(
            center: widget.center,
            particles: _particles,
            progress: t,
          ),
        );
      },
    );
  }
}

class _ExplosionPainter extends CustomPainter {
  final Offset center;
  final List<_Particle> particles;
  final double progress;

  _ExplosionPainter({
    required this.center,
    required this.particles,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      final currentPos = center + particle.velocity * progress;
      final currentSize = particle.size * (1 - progress);
      // CORRECTION : Remplacement de withValues par withOpacity
      final opacity = (1 - progress).clamp(0.0, 1.0);

      if (currentSize <= 0) continue;

      final paint = Paint()
        ..color = particle.color.withOpacity(opacity)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(currentPos, currentSize / 2, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class ExplosionOverlay extends StatelessWidget {
  final List<Offset> centers;
  final List<Color> colors;
  final VoidCallback? onComplete;

  const ExplosionOverlay({
    super.key,
    required this.centers,
    required this.colors,
    this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: List.generate(centers.length, (i) {
        return ExplosionAnimation(
          center: centers[i],
          color: colors[i % colors.length],
          onComplete: i == 0 ? onComplete : null,
        );
      }),
    );
  }
}