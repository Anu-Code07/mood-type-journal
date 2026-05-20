import '../entities/journal_entry.dart';
import '../entities/mood_profile.dart';
import '../repositories/moodtype_repository.dart';

class AnalyzeJournalEntry {
  const AnalyzeJournalEntry(this._repository);

  final MoodTypeRepository _repository;

  Future<MoodProfile> call(JournalEntry entry) {
    return _repository.analyzeMood(entry);
  }
}
