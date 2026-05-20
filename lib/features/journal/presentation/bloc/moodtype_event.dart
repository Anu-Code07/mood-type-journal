import 'package:equatable/equatable.dart';

enum TypographyMode {
  lowercase,
  uppercase,
  titleCase,
  aestheticSpacing,
  poetic,
  handwritten,
  kinetic,
}

sealed class MoodTypeEvent extends Equatable {
  const MoodTypeEvent();

  @override
  List<Object?> get props => <Object?>[];
}

class JournalTextChanged extends MoodTypeEvent {
  const JournalTextChanged(this.text);

  final String text;

  @override
  List<Object?> get props => <Object?>[text];
}

class MoodEmojiSelected extends MoodTypeEvent {
  const MoodEmojiSelected(this.emoji);

  final String emoji;

  @override
  List<Object?> get props => <Object?>[emoji];
}

class QuickTagToggled extends MoodTypeEvent {
  const QuickTagToggled(this.tag);

  final String tag;

  @override
  List<Object?> get props => <Object?>[tag];
}

class AnalyzePressed extends MoodTypeEvent {
  const AnalyzePressed();
}

class TypographyModeChanged extends MoodTypeEvent {
  const TypographyModeChanged(this.mode);

  final TypographyMode mode;

  @override
  List<Object?> get props => <Object?>[mode];
}

class WallpaperSettingChanged extends MoodTypeEvent {
  const WallpaperSettingChanged({
    this.textureStrength,
    this.blurStrength,
    this.fontFamily,
  });

  final double? textureStrength;
  final double? blurStrength;
  final String? fontFamily;

  @override
  List<Object?> get props => <Object?>[textureStrength, blurStrength, fontFamily];
}

class SaveJournalExperiencePressed extends MoodTypeEvent {
  const SaveJournalExperiencePressed();
}

class LoadTimelineRequested extends MoodTypeEvent {
  const LoadTimelineRequested();
}
