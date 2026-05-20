import '../entities/journal_entry.dart';
import '../entities/mood_profile.dart';
import '../entities/wallpaper_preview.dart';
import '../repositories/moodtype_repository.dart';

class GenerateWallpaperPreview {
  const GenerateWallpaperPreview(this._repository);

  final MoodTypeRepository _repository;

  Future<WallpaperPreview> call({
    required JournalEntry entry,
    required MoodProfile moodProfile,
  }) {
    return _repository.generateWallpaper(
      entry: entry,
      moodProfile: moodProfile,
    );
  }
}
