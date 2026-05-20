import 'dart:math';

import 'package:flutter/material.dart';

class AnimatedAmbientBackground extends StatefulWidget {
  const AnimatedAmbientBackground({
    required this.child,
    required this.palette,
    super.key,
  });

  final Widget child;
  final List<Color> palette;

  @override
  State<AnimatedAmbientBackground> createState() =>
      _AnimatedAmbientBackgroundState();
}

class _AnimatedAmbientBackgroundState extends State<AnimatedAmbientBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 18),
      vsync: this,
    )..repeat(reverse: true);
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
      child: widget.child,
      builder: (BuildContext context, Widget? child) {
        final double t = _controller.value;
        return DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(-1 + (2 * t), -1),
              end: Alignment(1, 1 - (2 * t)),
              colors: widget.palette,
            ),
          ),
          child: CustomPaint(
            painter: _NoisePainter(progress: t),
            child: child,
          ),
        );
      },
    );
  }
}

class _NoisePainter extends CustomPainter {
  _NoisePainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..style = PaintingStyle.fill;
    final Random random = Random(42);

    for (int i = 0; i < 80; i++) {
      final double radius = random.nextDouble() * 90 + 20;
      final double dx =
          (random.nextDouble() * size.width + progress * 50) % size.width;
      final double dy =
          (random.nextDouble() * size.height + sin(progress * pi) * 30) %
              size.height;
      paint.color = Colors.white.withValues(alpha: 0.02 + random.nextDouble() * 0.05);
      canvas.drawCircle(Offset(dx, dy), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _NoisePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
