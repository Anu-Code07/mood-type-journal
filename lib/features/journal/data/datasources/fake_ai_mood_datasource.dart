import 'dart:math';

import '../../domain/entities/journal_entry.dart';
import '../models/mood_profile_model.dart';
import '../models/wallpaper_preview_model.dart';

class FakeAiMoodDatasource {
  const FakeAiMoodDatasource();

  Future<MoodProfileModel> analyze(JournalEntry entry) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));

    final String normalized = entry.content.toLowerCase();
    final _MoodSignals signals = _extractSignals(normalized);

    return MoodProfileModel(
      mood: signals.mood,
      energy: signals.energy,
      sentiment: signals.sentiment,
      keywords: signals.keywords,
      aestheticTheme: signals.theme,
      palette: signals.palette,
      reflectiveQuote: _buildReflectiveQuote(normalized, signals),
    );
  }

  Future<WallpaperPreviewModel> generateWallpaper({
    required JournalEntry entry,
    required MoodProfileModel profile,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 700));

    final List<String> fonts = <String>[
      'Outfit',
      'Manrope',
      'Space Grotesk',
      'Plus Jakarta Sans',
    ];
    final int seed = entry.content.length + profile.mood.length;
    final Random random = Random(seed);

    return WallpaperPreviewModel(
      quote: profile.reflectiveQuote,
      layoutStyle: _pickLayout(profile.mood),
      textureStrength: 0.25 + random.nextDouble() * 0.4,
      blurStrength: 0.15 + random.nextDouble() * 0.3,
      palette: profile.palette,
      fontFamily: fonts[random.nextInt(fonts.length)],
    );
  }

  _MoodSignals _extractSignals(String text) {
    final bool hasCalmWord =
        text.contains('peace') || text.contains('slow') || text.contains('quiet');
    final bool hasTiredWord =
        text.contains('exhausted') || text.contains('drained') || text.contains('tired');
    final bool hasProudWord = text.contains('proud') || text.contains('accomplish');
    final bool hasSadWord = text.contains('lost') || text.contains('hurt') || text.contains('heavy');
    final bool hasHealingWord = text.contains('heal') || text.contains('recover');

    if (hasCalmWord) {
      return const _MoodSignals(
        mood: 'peaceful',
        energy: 'low',
        sentiment: 'positive',
        theme: 'japanese minimal',
        palette: <int>[0xFF0F172A, 0xFF334155, 0xFF6EE7B7],
        keywords: <String>['stillness', 'slow', 'breath'],
      );
    }

    if (hasTiredWord && hasProudWord) {
      return const _MoodSignals(
        mood: 'resilient',
        energy: 'medium',
        sentiment: 'mixed',
        theme: 'dark academia',
        palette: <int>[0xFF1C1917, 0xFF57534E, 0xFFD6D3D1],
        keywords: <String>['effort', 'growth', 'pride'],
      );
    }

    if (hasSadWord || hasHealingWord) {
      return const _MoodSignals(
        mood: 'healing',
        energy: 'low',
        sentiment: 'negative',
        theme: 'rainy-night aesthetics',
        palette: <int>[0xFF030712, 0xFF1D4ED8, 0xFF60A5FA],
        keywords: <String>['healing', 'patience', 'night'],
      );
    }

    return const _MoodSignals(
      mood: 'reflective',
      energy: 'balanced',
      sentiment: 'mixed',
      theme: 'dreamy pastel',
      palette: <int>[0xFF111827, 0xFF7C3AED, 0xFFF9A8D4],
      keywords: <String>['memory', 'emotion', 'story'],
    );
  }

  String _buildReflectiveQuote(String text, _MoodSignals signals) {
    if (text.contains('lost')) {
      return 'Not every wandering soul is lost.';
    }
    if (signals.mood == 'peaceful') {
      return 'Slow days still move your life forward.';
    }
    if (signals.mood == 'resilient') {
      return 'You carried the weight and still kept your light.';
    }
    if (signals.mood == 'healing') {
      return 'Healing takes time, but you are already becoming.';
    }
    return 'Your story is still unfolding in beautiful gradients.';
  }

  String _pickLayout(String mood) {
    switch (mood) {
      case 'peaceful':
        return 'left aligned haiku';
      case 'resilient':
        return 'center cinematic stack';
      case 'healing':
        return 'lower-third whisper';
      default:
        return 'floating center quote';
    }
  }
}

class _MoodSignals {
  const _MoodSignals({
    required this.mood,
    required this.energy,
    required this.sentiment,
    required this.theme,
    required this.palette,
    required this.keywords,
  });

  final String mood;
  final String energy;
  final String sentiment;
  final String theme;
  final List<int> palette;
  final List<String> keywords;
}
