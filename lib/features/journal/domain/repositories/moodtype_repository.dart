import '../entities/journal_entry.dart';
import '../entities/mood_profile.dart';
import '../entities/wallpaper_preview.dart';

abstract class MoodTypeRepository {
  Future<MoodProfile> analyzeMood(JournalEntry entry);

  Future<WallpaperPreview> generateWallpaper({
    required JournalEntry entry,
    required MoodProfile moodProfile,
  });

  Future<void> saveEntry({
    required JournalEntry entry,
    required MoodProfile moodProfile,
    required WallpaperPreview wallpaperPreview,
  });

  Future<List<JournalTimelineItem>> getTimeline();
}

class JournalTimelineItem {
  const JournalTimelineItem({
    required this.entry,
    required this.moodProfile,
    required this.wallpaperPreview,
  });

  final JournalEntry entry;
  final MoodProfile moodProfile;
  final WallpaperPreview wallpaperPreview;
}
