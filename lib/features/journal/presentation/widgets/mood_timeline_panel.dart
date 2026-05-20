import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/widgets/glass_panel.dart';
import '../../domain/repositories/moodtype_repository.dart';

class MoodTimelinePanel extends StatelessWidget {
  const MoodTimelinePanel({required this.items, super.key});

  final List<JournalTimelineItem> items;

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Mood Timeline',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Spotify Wrapped emotions × Apple Health trends × Pinterest visual memory.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: 12),
          if (items.isEmpty)
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white.withValues(alpha: 0.08),
              ),
              child: const Text(
                'Your emotional timeline will appear here after saving entries.',
              ),
            )
          else
            ListView.separated(
              itemCount: items.take(8).length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              separatorBuilder: (_, __) => const Divider(height: 20),
              itemBuilder: (BuildContext context, int index) {
                final JournalTimelineItem item = items[index];
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    CircleAvatar(
                      radius: 19,
                      backgroundColor: Color(item.moodProfile.palette.first),
                      child: Text(item.entry.emoji),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            item.moodProfile.reflectiveQuote,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.entry.content,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 6),
                          Wrap(
                            spacing: 8,
                            children: <Widget>[
                              _MetaChip(item.moodProfile.mood),
                              _MetaChip(item.moodProfile.energy),
                              _MetaChip(
                                DateFormat('MMM d • HH:mm')
                                    .format(item.entry.createdAt),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
        ],
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: Colors.white.withValues(alpha: 0.1),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelSmall,
      ),
    );
  }
}
