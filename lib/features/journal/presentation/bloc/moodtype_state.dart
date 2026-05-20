import 'package:equatable/equatable.dart';

import '../../domain/entities/mood_profile.dart';
import '../../domain/entities/wallpaper_preview.dart';
import '../../domain/repositories/moodtype_repository.dart';
import 'moodtype_event.dart';

class MoodTypeViewData extends Equatable {
  const MoodTypeViewData({
    this.journalText = '',
    this.selectedEmoji = '🙂',
    this.quickTags = const <String>[],
    this.typographyMode = TypographyMode.lowercase,
    this.moodProfile,
    this.wallpaperPreview,
    this.timeline = const <JournalTimelineItem>[],
  });

  final String journalText;
  final String selectedEmoji;
  final List<String> quickTags;
  final TypographyMode typographyMode;
  final MoodProfile? moodProfile;
  final WallpaperPreview? wallpaperPreview;
  final List<JournalTimelineItem> timeline;

  MoodTypeViewData copyWith({
    String? journalText,
    String? selectedEmoji,
    List<String>? quickTags,
    TypographyMode? typographyMode,
    MoodProfile? moodProfile,
    WallpaperPreview? wallpaperPreview,
    List<JournalTimelineItem>? timeline,
    bool clearMood = false,
    bool clearWallpaper = false,
  }) {
    return MoodTypeViewData(
      journalText: journalText ?? this.journalText,
      selectedEmoji: selectedEmoji ?? this.selectedEmoji,
      quickTags: quickTags ?? this.quickTags,
      typographyMode: typographyMode ?? this.typographyMode,
      moodProfile: clearMood ? null : (moodProfile ?? this.moodProfile),
      wallpaperPreview: clearWallpaper
          ? null
          : (wallpaperPreview ?? this.wallpaperPreview),
      timeline: timeline ?? this.timeline,
    );
  }

  @override
  List<Object?> get props => <Object?>[
        journalText,
        selectedEmoji,
        quickTags,
        typographyMode,
        moodProfile,
        wallpaperPreview,
        timeline,
      ];
}

sealed class MoodTypeState extends Equatable {
  const MoodTypeState(this.data);

  final MoodTypeViewData data;

  @override
  List<Object?> get props => <Object?>[data];
}

class MoodTypeInitial extends MoodTypeState {
  const MoodTypeInitial(super.data);
}

class MoodTypeLoading extends MoodTypeState {
  const MoodTypeLoading(super.data);
}

class MoodTypeReady extends MoodTypeState {
  const MoodTypeReady(super.data);
}

class MoodTypeSaving extends MoodTypeState {
  const MoodTypeSaving(super.data);
}

class MoodTypeSaved extends MoodTypeState {
  const MoodTypeSaved(super.data);
}

class MoodTypeError extends MoodTypeState {
  const MoodTypeError({
    required super.data,
    required this.message,
  });

  final String message;

  @override
  List<Object?> get props => <Object?>[data, message];
}
