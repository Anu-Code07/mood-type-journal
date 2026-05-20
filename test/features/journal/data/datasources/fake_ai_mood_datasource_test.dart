import 'package:flutter_test/flutter_test.dart';
import 'package:mood_type_journal/features/journal/data/datasources/fake_ai_mood_datasource.dart';
import 'package:mood_type_journal/features/journal/domain/entities/journal_entry.dart';

void main() {
  group('FakeAiMoodDatasource', () {
    test('detects peaceful tone from calm language', () async {
      const FakeAiMoodDatasource datasource = FakeAiMoodDatasource();
      final JournalEntry entry = JournalEntry(
        id: '1',
        content: 'Today felt peaceful and slow.',
        createdAt: DateTime(2026, 1, 1),
        quickTags: <String>['peaceful'],
        emoji: '😌',
      );

      final profile = await datasource.analyze(entry);

      expect(profile.mood, 'peaceful');
      expect(profile.aestheticTheme, 'japanese minimal');
    });
  });
}
