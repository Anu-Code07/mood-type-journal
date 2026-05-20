import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/glass_panel.dart';
import '../bloc/moodtype_bloc.dart';
import '../bloc/moodtype_event.dart';
import '../bloc/moodtype_state.dart';

class TypographyTransformerPanel extends StatelessWidget {
  const TypographyTransformerPanel({required this.data, super.key});

  final MoodTypeViewData data;

  @override
  Widget build(BuildContext context) {
    final String source = data.journalText.trim().isEmpty
        ? 'i survived today.'
        : data.journalText.trim().split('\n').first;
    final String transformed = _transform(source, data.typographyMode);

    return GlassPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Typography Transformation Engine',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: TypographyMode.values.map((TypographyMode mode) {
              return ChoiceChip(
                label: Text(_modeLabel(mode)),
                selected: mode == data.typographyMode,
                onSelected: (_) =>
                    context.read<MoodTypeBloc>().add(TypographyModeChanged(mode)),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 550),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(
                opacity: animation,
                child: ScaleTransition(scale: animation, child: child),
              );
            },
            child: _AnimatedTypographyCanvas(
              key: ValueKey<String>('${data.typographyMode.name}_$transformed'),
              text: transformed,
              mode: data.typographyMode,
            ),
          ),
        ],
      ),
    );
  }

  String _modeLabel(TypographyMode mode) {
    switch (mode) {
      case TypographyMode.lowercase:
        return 'lowercase';
      case TypographyMode.uppercase:
        return 'UPPERCASE';
      case TypographyMode.titleCase:
        return 'Title Case';
      case TypographyMode.aestheticSpacing:
        return 'aesthetic spacing';
      case TypographyMode.poetic:
        return 'poetic';
      case TypographyMode.handwritten:
        return 'handwritten';
      case TypographyMode.kinetic:
        return 'kinetic';
    }
  }

  String _transform(String input, TypographyMode mode) {
    switch (mode) {
      case TypographyMode.lowercase:
        return input.toLowerCase();
      case TypographyMode.uppercase:
        return input.toUpperCase();
      case TypographyMode.titleCase:
        return input
            .split(' ')
            .where((String word) => word.isNotEmpty)
            .map((String word) =>
                '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}')
            .join(' ');
      case TypographyMode.aestheticSpacing:
        return input
            .toUpperCase()
            .split('')
            .join(' ')
            .replaceAll('  ', '   ')
            .trim();
      case TypographyMode.poetic:
        return input.replaceAll('.', '  ·').replaceAll(',', '  /');
      case TypographyMode.handwritten:
        return '${input.toLowerCase()} ~';
      case TypographyMode.kinetic:
        return input.toUpperCase();
    }
  }
}

class _AnimatedTypographyCanvas extends StatefulWidget {
  const _AnimatedTypographyCanvas({
    required this.text,
    required this.mode,
    super.key,
  });

  final String text;
  final TypographyMode mode;

  @override
  State<_AnimatedTypographyCanvas> createState() => _AnimatedTypographyCanvasState();
}

class _AnimatedTypographyCanvasState extends State<_AnimatedTypographyCanvas>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1800),
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
    final TextStyle style = Theme.of(context).textTheme.headlineSmall!.copyWith(
          fontWeight: FontWeight.w700,
          letterSpacing: widget.mode == TypographyMode.aestheticSpacing ? 3 : 1,
          color: Colors.white,
        );

    return SizedBox(
      height: 170,
      width: double.infinity,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (BuildContext context, Widget? child) {
          final double t = _controller.value;
          final double waveOffset =
              widget.mode == TypographyMode.kinetic ? sin(t * pi * 2) * 10 : 0;
          final double glow = widget.mode == TypographyMode.uppercase ? 18 * t : 6;

          return DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              gradient: LinearGradient(
                colors: <Color>[
                  Colors.white.withValues(alpha: 0.05),
                  Colors.white.withValues(alpha: 0.02),
                ],
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.cyanAccent.withValues(alpha: 0.15),
                  blurRadius: glow,
                ),
              ],
            ),
            child: CustomPaint(
              painter: _RipplePainter(intensity: t),
              child: Center(
                child: Transform.translate(
                  offset: Offset(0, waveOffset),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      widget.text,
                      textAlign: TextAlign.center,
                      style: style,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _RipplePainter extends CustomPainter {
  _RipplePainter({required this.intensity});

  final double intensity;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..color = Colors.white.withValues(alpha: 0.18);

    for (int i = 0; i < 4; i++) {
      final Rect rect = Rect.fromCenter(
        center: Offset(size.width / 2, size.height / 2),
        width: size.width * (0.3 + i * 0.25 + intensity * 0.12),
        height: size.height * (0.22 + i * 0.2 + intensity * 0.08),
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(18)),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _RipplePainter oldDelegate) {
    return oldDelegate.intensity != intensity;
  }
}
