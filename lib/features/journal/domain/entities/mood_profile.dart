import 'package:equatable/equatable.dart';

class MoodProfile extends Equatable {
  const MoodProfile({
    required this.mood,
    required this.energy,
    required this.sentiment,
    required this.keywords,
    required this.aestheticTheme,
    required this.palette,
    required this.reflectiveQuote,
  });

  final String mood;
  final String energy;
  final String sentiment;
  final List<String> keywords;
  final String aestheticTheme;
  final List<int> palette;
  final String reflectiveQuote;

  @override
  List<Object?> get props => <Object?>[
        mood,
        energy,
        sentiment,
        keywords,
        aestheticTheme,
        palette,
        reflectiveQuote,
      ];
}
