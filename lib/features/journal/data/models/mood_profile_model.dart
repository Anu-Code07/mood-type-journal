import '../../domain/entities/mood_profile.dart';

class MoodProfileModel extends MoodProfile {
  const MoodProfileModel({
    required super.mood,
    required super.energy,
    required super.sentiment,
    required super.keywords,
    required super.aestheticTheme,
    required super.palette,
    required super.reflectiveQuote,
  });

  factory MoodProfileModel.fromEntity(MoodProfile profile) {
    return MoodProfileModel(
      mood: profile.mood,
      energy: profile.energy,
      sentiment: profile.sentiment,
      keywords: profile.keywords,
      aestheticTheme: profile.aestheticTheme,
      palette: profile.palette,
      reflectiveQuote: profile.reflectiveQuote,
    );
  }

  factory MoodProfileModel.fromMap(Map<String, dynamic> map) {
    return MoodProfileModel(
      mood: map['mood'] as String? ?? 'neutral',
      energy: map['energy'] as String? ?? 'balanced',
      sentiment: map['sentiment'] as String? ?? 'mixed',
      keywords: (map['keywords'] as List<dynamic>? ?? <dynamic>[])
          .map((dynamic item) => item.toString())
          .toList(),
      aestheticTheme: map['aestheticTheme'] as String? ?? 'japanese minimal',
      palette: (map['palette'] as List<dynamic>? ?? <dynamic>[])
          .map((dynamic item) => item as int? ?? 0xFF111111)
          .toList(),
      reflectiveQuote: map['reflectiveQuote'] as String? ?? 'Slowly, you bloom.',
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'mood': mood,
      'energy': energy,
      'sentiment': sentiment,
      'keywords': keywords,
      'aestheticTheme': aestheticTheme,
      'palette': palette,
      'reflectiveQuote': reflectiveQuote,
    };
  }
}
