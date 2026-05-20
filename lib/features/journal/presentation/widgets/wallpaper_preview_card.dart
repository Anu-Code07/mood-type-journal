import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/glass_panel.dart';
import '../bloc/moodtype_bloc.dart';
import '../bloc/moodtype_event.dart';
import '../bloc/moodtype_state.dart';

class WallpaperPreviewCard extends StatelessWidget {
  const WallpaperPreviewCard({required this.data, super.key});

  final MoodTypeViewData data;

  @override
  Widget build(BuildContext context) {
    final preview = data.wallpaperPreview;
    final String selectedFont = preview?.fontFamily ?? 'Outfit';
    return GlassPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'AI Mood Wallpaper Studio',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 10),
          Text(
            preview != null
                ? 'Real-time lockscreen studio with grain, blur, and cinematic quote layout.'
                : 'Press Transform Mood to generate your first emotional wallpaper.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white70,
                ),
          ),
          const SizedBox(height: 16),
          _WallpaperCanvas(
            quote: preview?.quote ?? 'healing takes time',
            palette: preview?.palette ?? const <int>[0xFF0B1120, 0xFF1D4ED8, 0xFF93C5FD],
            blurStrength: preview?.blurStrength ?? 0.2,
            textureStrength: preview?.textureStrength ?? 0.35,
          ),
          if (preview != null) ...<Widget>[
            const SizedBox(height: 16),
            _LabeledSlider(
              label: 'Grain intensity',
              value: preview.textureStrength,
              onChanged: (double value) => context.read<MoodTypeBloc>().add(
                    WallpaperSettingChanged(textureStrength: value),
                  ),
            ),
            _LabeledSlider(
              label: 'Blur softness',
              value: preview.blurStrength,
              onChanged: (double value) => context.read<MoodTypeBloc>().add(
                    WallpaperSettingChanged(blurStrength: value),
                  ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: const <String>[
                'Outfit',
                'Manrope',
                'Space Grotesk',
                'Plus Jakarta Sans',
              ].map((String font) {
                return ChoiceChip(
                  label: Text(font),
                  selected: selectedFont == font,
                  onSelected: (_) => context.read<MoodTypeBloc>().add(
                        WallpaperSettingChanged(fontFamily: font),
                      ),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
            Row(
              children: <Widget>[
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _showExportInfo(context),
                    icon: const Icon(Icons.wallpaper),
                    label: const Text('Save to Gallery'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _showExportInfo(context),
                    icon: const Icon(Icons.movie_creation_outlined),
                    label: const Text('Export Reel'),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  void _showExportInfo(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Hook screenshot/video export engine here (HD, AMOLED, animated clip).',
        ),
      ),
    );
  }
}

class _WallpaperCanvas extends StatelessWidget {
  const _WallpaperCanvas({
    required this.quote,
    required this.palette,
    required this.blurStrength,
    required this.textureStrength,
  });

  final String quote;
  final List<int> palette;
  final double blurStrength;
  final double textureStrength;

  @override
  Widget build(BuildContext context) {
    final List<Color> colors = palette.map((int value) => Color(value)).toList();
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: AspectRatio(
        aspectRatio: 9 / 19.5,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: colors,
                ),
              ),
            ),
            BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 10 + blurStrength * 30,
                sigmaY: 10 + blurStrength * 30,
              ),
              child: const SizedBox.expand(),
            ),
            CustomPaint(
              painter: _GrainPainter(intensity: textureStrength),
            ),
            Padding(
              padding: const EdgeInsets.all(28),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  quote,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        shadows: <Shadow>[
                          Shadow(
                            color: Colors.black.withValues(alpha: 0.35),
                            blurRadius: 10,
                          ),
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
}

class _GrainPainter extends CustomPainter {
  _GrainPainter({required this.intensity});

  final double intensity;

  @override
  void paint(Canvas canvas, Size size) {
    final Random random = Random(13);
    final Paint paint = Paint();
    final int points = (size.width * size.height * 0.0025 * intensity).toInt();
    for (int i = 0; i < points; i++) {
      paint.color = Colors.white.withValues(alpha: random.nextDouble() * 0.08);
      canvas.drawCircle(
        Offset(random.nextDouble() * size.width, random.nextDouble() * size.height),
        random.nextDouble() * 1.2,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _GrainPainter oldDelegate) {
    return oldDelegate.intensity != intensity;
  }
}

class _LabeledSlider extends StatelessWidget {
  const _LabeledSlider({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final double value;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
        Slider(
          value: value.clamp(0.0, 1.0).toDouble(),
          min: 0,
          max: 1,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
