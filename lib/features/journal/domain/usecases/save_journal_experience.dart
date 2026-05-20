import '../entities/journal_entry.dart';
import '../entities/mood_profile.dart';
import '../entities/wallpaper_preview.dart';
import '../repositories/moodtype_repository.dart';

class SaveJournalExperience {
  const SaveJournalExperience(this._repository);

  final MoodTypeRepository _repository;

  Future<void> call({
    required JournalEntry entry,
    required MoodProfile moodProfile,
    required WallpaperPreview wallpaperPreview,
  }) {
    return _repository.saveEntry(
      entry: entry,
      moodProfile: moodProfile,
      wallpaperPreview: wallpaperPreview,
    );
  }
}
