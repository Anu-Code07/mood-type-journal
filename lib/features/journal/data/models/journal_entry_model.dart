import '../../domain/entities/journal_entry.dart';

class JournalEntryModel extends JournalEntry {
  const JournalEntryModel({
    required super.id,
    required super.content,
    required super.createdAt,
    required super.quickTags,
    required super.emoji,
  });

  factory JournalEntryModel.fromEntity(JournalEntry entry) {
    return JournalEntryModel(
      id: entry.id,
      content: entry.content,
      createdAt: entry.createdAt,
      quickTags: entry.quickTags,
      emoji: entry.emoji,
    );
  }

  factory JournalEntryModel.fromMap(Map<String, dynamic> map) {
    return JournalEntryModel(
      id: map['id'] as String? ?? '',
      content: map['content'] as String? ?? '',
      createdAt: DateTime.tryParse(map['createdAt'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
      quickTags: (map['quickTags'] as List<dynamic>? ?? <dynamic>[])
          .map((dynamic item) => item.toString())
          .toList(),
      emoji: map['emoji'] as String? ?? '🙂',
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'quickTags': quickTags,
      'emoji': emoji,
    };
  }
}
