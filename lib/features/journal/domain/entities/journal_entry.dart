import 'package:equatable/equatable.dart';

class JournalEntry extends Equatable {
  const JournalEntry({
    required this.id,
    required this.content,
    required this.createdAt,
    required this.quickTags,
    required this.emoji,
  });

  final String id;
  final String content;
  final DateTime createdAt;
  final List<String> quickTags;
  final String emoji;

  @override
  List<Object?> get props => <Object?>[id, content, createdAt, quickTags, emoji];
}
