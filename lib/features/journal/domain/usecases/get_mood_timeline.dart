import '../repositories/moodtype_repository.dart';

class GetMoodTimeline {
  const GetMoodTimeline(this._repository);

  final MoodTypeRepository _repository;

  Future<List<JournalTimelineItem>> call() {
    return _repository.getTimeline();
  }
}
