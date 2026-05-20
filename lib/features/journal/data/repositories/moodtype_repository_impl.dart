import '../../domain/entities/journal_entry.dart';
import '../../domain/entities/mood_profile.dart';
import '../../domain/entities/wallpaper_preview.dart';
import '../../domain/repositories/moodtype_repository.dart';
import '../datasources/fake_ai_mood_datasource.dart';
import '../datasources/local_journal_datasource.dart';
import '../models/journal_entry_model.dart';
import '../models/mood_profile_model.dart';
import '../models/wallpaper_preview_model.dart';

class MoodTypeRepositoryImpl implements MoodTypeRepository {
  const MoodTypeRepositoryImpl({
    required FakeAiMoodDatasource moodAiDatasource,
    required LocalJournalDatasource localJournalDatasource,
  })  : _moodAiDatasource = moodAiDatasource,
        _localJournalDatasource = localJournalDatasource;

  final FakeAiMoodDatasource _moodAiDatasource;
  final LocalJournalDatasource _localJournalDatasource;

  @override
  Future<MoodProfile> analyzeMood(JournalEntry entry) {
    return _moodAiDatasource.analyze(entry);
  }

  @override
  Future<WallpaperPreview> generateWallpaper({
    required JournalEntry entry,
    required MoodProfile moodProfile,
  }) {
    return _moodAiDatasource.generateWallpaper(
      entry: entry,
      profile: MoodProfileModel.fromEntity(moodProfile),
    );
  }

  @override
  Future<void> saveEntry({
    required JournalEntry entry,
    required MoodProfile moodProfile,
    required WallpaperPreview wallpaperPreview,
  }) {
    return _localJournalDatasource.saveTimelineItem(
      entry: JournalEntryModel.fromEntity(entry),
      moodProfile: MoodProfileModel.fromEntity(moodProfile),
      wallpaper: WallpaperPreviewModel.fromEntity(wallpaperPreview),
    );
  }

  @override
  Future<List<JournalTimelineItem>> getTimeline() {
    return _localJournalDatasource.fetchTimelineItems();
  }
}
