import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/journal_entry.dart';
import '../../domain/entities/wallpaper_preview.dart';
import '../../domain/usecases/analyze_journal_entry.dart';
import '../../domain/usecases/generate_wallpaper_preview.dart';
import '../../domain/usecases/get_mood_timeline.dart';
import '../../domain/usecases/save_journal_experience.dart';
import 'moodtype_event.dart';
import 'moodtype_state.dart';

class MoodTypeBloc extends Bloc<MoodTypeEvent, MoodTypeState> {
  MoodTypeBloc({
    required AnalyzeJournalEntry analyzeJournalEntry,
    required GenerateWallpaperPreview generateWallpaperPreview,
    required SaveJournalExperience saveJournalExperience,
    required GetMoodTimeline getMoodTimeline,
  })  : _analyzeJournalEntry = analyzeJournalEntry,
        _generateWallpaperPreview = generateWallpaperPreview,
        _saveJournalExperience = saveJournalExperience,
        _getMoodTimeline = getMoodTimeline,
        super(const MoodTypeInitial(MoodTypeViewData())) {
    on<JournalTextChanged>(_onJournalTextChanged);
    on<MoodEmojiSelected>(_onMoodEmojiSelected);
    on<QuickTagToggled>(_onQuickTagToggled);
    on<TypographyModeChanged>(_onTypographyModeChanged);
    on<AnalyzePressed>(_onAnalyzePressed);
    on<WallpaperSettingChanged>(_onWallpaperSettingChanged);
    on<SaveJournalExperiencePressed>(_onSaveJournalExperiencePressed);
    on<LoadTimelineRequested>(_onLoadTimelineRequested);

    add(const LoadTimelineRequested());
  }

  final AnalyzeJournalEntry _analyzeJournalEntry;
  final GenerateWallpaperPreview _generateWallpaperPreview;
  final SaveJournalExperience _saveJournalExperience;
  final GetMoodTimeline _getMoodTimeline;
  final Uuid _uuid = const Uuid();

  void _onJournalTextChanged(JournalTextChanged event, Emitter<MoodTypeState> emit) {
    emit(MoodTypeReady(state.data.copyWith(journalText: event.text)));
  }

  void _onMoodEmojiSelected(MoodEmojiSelected event, Emitter<MoodTypeState> emit) {
    emit(MoodTypeReady(state.data.copyWith(selectedEmoji: event.emoji)));
  }

  void _onQuickTagToggled(QuickTagToggled event, Emitter<MoodTypeState> emit) {
    final List<String> nextTags = List<String>.from(state.data.quickTags);
    if (nextTags.contains(event.tag)) {
      nextTags.remove(event.tag);
    } else {
      nextTags.add(event.tag);
    }
    emit(MoodTypeReady(state.data.copyWith(quickTags: nextTags)));
  }

  void _onTypographyModeChanged(
    TypographyModeChanged event,
    Emitter<MoodTypeState> emit,
  ) {
    emit(MoodTypeReady(state.data.copyWith(typographyMode: event.mode)));
  }

  Future<void> _onAnalyzePressed(
    AnalyzePressed event,
    Emitter<MoodTypeState> emit,
  ) async {
    final String content = state.data.journalText.trim();
    if (content.isEmpty) {
      emit(
        MoodTypeError(
          data: state.data,
          message: 'Write a short moment first so AI can shape your mood scene.',
        ),
      );
      return;
    }

    emit(MoodTypeLoading(state.data));
    try {
      final JournalEntry entry = JournalEntry(
        id: _uuid.v4(),
        content: content,
        createdAt: DateTime.now(),
        quickTags: state.data.quickTags,
        emoji: state.data.selectedEmoji,
      );

      final moodProfile = await _analyzeJournalEntry(entry);
      final wallpaperPreview = await _generateWallpaperPreview(
        entry: entry,
        moodProfile: moodProfile,
      );

      emit(
        MoodTypeReady(
          state.data.copyWith(
            moodProfile: moodProfile,
            wallpaperPreview: wallpaperPreview,
          ),
        ),
      );
    } catch (_) {
      emit(
        MoodTypeError(
          data: state.data,
          message: 'Mood analysis failed. Please retry in a few seconds.',
        ),
      );
    }
  }

  void _onWallpaperSettingChanged(
    WallpaperSettingChanged event,
    Emitter<MoodTypeState> emit,
  ) {
    final WallpaperPreview? current = state.data.wallpaperPreview;
    if (current == null) {
      return;
    }

    emit(
      MoodTypeReady(
        state.data.copyWith(
          wallpaperPreview: current.copyWith(
            textureStrength: event.textureStrength,
            blurStrength: event.blurStrength,
            fontFamily: event.fontFamily,
          ),
        ),
      ),
    );
  }

  Future<void> _onSaveJournalExperiencePressed(
    SaveJournalExperiencePressed event,
    Emitter<MoodTypeState> emit,
  ) async {
    final moodProfile = state.data.moodProfile;
    final wallpaperPreview = state.data.wallpaperPreview;
    if (moodProfile == null || wallpaperPreview == null) {
      emit(
        MoodTypeError(
          data: state.data,
          message: 'Generate mood and wallpaper first before saving timeline.',
        ),
      );
      return;
    }

    emit(MoodTypeSaving(state.data));
    try {
      final JournalEntry entry = JournalEntry(
        id: _uuid.v4(),
        content: state.data.journalText.trim(),
        createdAt: DateTime.now(),
        quickTags: state.data.quickTags,
        emoji: state.data.selectedEmoji,
      );

      await _saveJournalExperience(
        entry: entry,
        moodProfile: moodProfile,
        wallpaperPreview: wallpaperPreview,
      );

      final timeline = await _getMoodTimeline();
      emit(
        MoodTypeSaved(
          state.data.copyWith(
            timeline: timeline,
          ),
        ),
      );
    } catch (_) {
      emit(
        MoodTypeError(
          data: state.data,
          message: 'Saving failed. Check storage permission and retry.',
        ),
      );
    }
  }

  Future<void> _onLoadTimelineRequested(
    LoadTimelineRequested event,
    Emitter<MoodTypeState> emit,
  ) async {
    try {
      final timeline = await _getMoodTimeline();
      emit(MoodTypeReady(state.data.copyWith(timeline: timeline)));
    } catch (_) {
      emit(
        MoodTypeError(
          data: state.data,
          message: 'Could not load your emotional timeline yet.',
        ),
      );
    }
  }
}
